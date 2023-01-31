import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { workoutGeneratorV2 } from "../../../service/workout_manager/workout_generator/workout_generator";
import { Workout } from "@prisma/client";
import { AppContext } from "../../../types/contextType";
import { getActiveWorkout } from "../../../service/workout_manager/utils";
import { assert } from "console";
import { MutationRefreshProgramArgs } from "../../../types/graphql";
import { checkExistsAndOwnershipOnSharedResource } from "./deleteProgramResolver";

/**
 * Regenerates AI_MANAGED workouts.
 * NOTE:
 *
 * 1. Workout generated are of type: WorkoutType.AI_MANAGED
 * 2. All existing active workouts of type: WorkoutType.AI_MANAGED are deleted
 */
export const refreshProgramResolver = async (
  _: unknown,
  { program_id, initial_days }: MutationRefreshProgramArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const programToRefresh = await prisma.program.findUniqueOrThrow({
    where: { program_id: parseInt(program_id) },
  });
  checkExistsAndOwnershipOnSharedResource({
    context: context,
    object: programToRefresh,
  });
  const no_of_workouts = context.base_user?.User?.workout_frequency ?? 3;

  assert(no_of_workouts > 0 && no_of_workouts <= 6);

  const { active_workouts } = await getActiveWorkout({
    context: context,
    program_id: program_id,
  });

  const days_of_week =
    initial_days ?? active_workouts.map((workout) => workout.date_scheduled);
  const activeWorkoutIDS = active_workouts.map(
    (workout: Workout) => workout.workout_id
  );
  // delete the existing active workouts
  await prisma.workout.deleteMany({
    where: {
      workout_id: {
        in: activeWorkoutIDS,
      },
      programProgram_id: parseInt(program_id),
    },
  });

  // generate new active workouts
  const refreshedWorkouts = await workoutGeneratorV2(
    days_of_week,
    context,
    parseInt(program_id)
  );
  return refreshedWorkouts!;
};
