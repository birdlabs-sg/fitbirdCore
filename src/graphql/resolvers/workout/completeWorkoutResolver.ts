import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { report } from "../../../service/slack/slack_service";
import { updateExcerciseMetadataWithCompletedWorkout } from "../../../service/workout_manager/exercise_metadata_manager/exercise_metadata_manager";
import { generateOrUpdateExcerciseMetadata } from "../../../service/workout_manager/exercise_metadata_manager/exercise_metadata_manager";
import {
  extractMetadatas,
  getActiveWorkout,
} from "../../../service/workout_manager/utils";
import { formatExcerciseSetGroups } from "../../../service/workout_manager/utils";
import { exerciseSetGroupStateSeperator } from "../../../service/workout_manager/utils";
import { checkExistsAndOwnership } from "../../../service/workout_manager/utils";
import { generateNextWorkout } from "../../../service/workout_manager/workout_generator/workout_generator";
import { AppContext } from "../../../types/contextType";
import { MutationCompleteWorkoutArgs } from "../../../types/graphql";

/**
 * Completed the workout specified by @workout_id
 *
 * NOTE:
 * 1. Client have to send in all the excercise_sets or it will be treated that the excercise_set is to be deleted
 * 2. Active workouts returned will belong to the same program as the workout being completed.
 */
export const completeWorkoutResolver = async (
  _: unknown,
  { workout_id, excercise_set_groups }: MutationCompleteWorkoutArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  await checkExistsAndOwnership({ context, workout_id });
  const prisma = context.dataSources.prisma;
  const [prismaExerciseSetGroupCreateArgs, excercise_metadatas] =
    extractMetadatas(excercise_set_groups);
  const [
    current_workout_excercise_group_sets,
    next_workout_excercise_group_sets,
  ] = exerciseSetGroupStateSeperator(prismaExerciseSetGroupCreateArgs);

  const completedWorkout = await prisma.workout.update({
    where: {
      workout_id: parseInt(workout_id),
    },
    data: {
      date_closed: new Date(),
      excercise_set_groups: {
        deleteMany: {},
        create: formatExcerciseSetGroups(current_workout_excercise_group_sets),
      },
    },
    include: {
      excercise_set_groups: { include: { excercise_sets: true } },
    },
  });
  // in-case there is no associated excercise metadata
  await generateOrUpdateExcerciseMetadata({ context, excercise_metadatas });

  await updateExcerciseMetadataWithCompletedWorkout(context, completedWorkout);

  await generateNextWorkout(
    context,
    completedWorkout,
    next_workout_excercise_group_sets
  );

  report(`${context.base_user?.displayName} completed a workout. ✅`);
  const { active_workouts } = await getActiveWorkout({
    context: context,
    program_id: JSON.stringify(completedWorkout.programProgram_id),
  });
  return {
    code: "200",
    success: true,
    message: "Successfully updated your workout!",
    workouts: active_workouts,
  };
};
