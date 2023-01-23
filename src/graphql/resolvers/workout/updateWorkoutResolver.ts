/**
 * Updates the workout specified by @workout_id
 */

import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { generateOrUpdateExcerciseMetadata } from "../../../service/workout_manager/exercise_metadata_manager/exercise_metadata_manager";
import { extractMetadatas } from "../../../service/workout_manager/utils";
import { formatExcerciseSetGroups } from "../../../service/workout_manager/utils";
import { AppContext } from "../../../types/contextType";
import { ExcerciseSetGroupInput } from "../../../types/graphql";
import { MutationUpdateWorkoutArgs } from "../../../types/graphql";
import { checkExistsAndOwnershipOnSharedResource } from "../program/deleteProgramResolver";

// modified the update workout to fit both coaches and users
export const updateWorkoutResolver = async (
  _: unknown,
  { workout_id, excercise_set_groups, ...otherArgs }: MutationUpdateWorkoutArgs,
  context: AppContext
) => {
  const prisma = context.dataSources.prisma;
  onlyAuthenticated(context);

  const programAffected = await prisma.program.findFirstOrThrow({
    where: {
      workouts: {
        some: {
          workout_id: parseInt(workout_id),
        },
      },
    },
  });

  checkExistsAndOwnershipOnSharedResource({
    context: context,
    object: programAffected,
  });

  let formatedUpdatedData;
  if (excercise_set_groups != null) {
    const [excerciseSetGroups, excercise_metadatas] = extractMetadatas(
      excercise_set_groups as ExcerciseSetGroupInput[]
    );
    formatedUpdatedData = {
      ...otherArgs,
      ...{
        excercise_set_groups: {
          deleteMany: {},
          create: formatExcerciseSetGroups(excerciseSetGroups),
        },
      },
    };
    await generateOrUpdateExcerciseMetadata({
      context,
      excercise_metadatas,
      user_id: programAffected.user_id.toString(),
    });
  } else {
    formatedUpdatedData = {
      ...otherArgs,
    };
  }

  const updatedWorkout = await prisma.workout.update({
    where: {
      workout_id: parseInt(workout_id),
    },
    data: formatedUpdatedData,
    include: {
      excercise_set_groups: { include: { excercise_sets: true } },
    },
  });

  return {
    code: "200",
    success: true,
    message: "Successfully updated your workout!",
    workout: updatedWorkout,
  };
};
