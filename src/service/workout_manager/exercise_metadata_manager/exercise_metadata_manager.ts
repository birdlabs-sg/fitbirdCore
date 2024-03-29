// Retreives the user's exerciseMetadata with respect to the specified exercise.

import { ExcerciseMetadata } from "@prisma/client";
import { ExcerciseMetaDataInput } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";
import { checkExerciseExists } from "../utils";
import { WorkoutWithExerciseSets } from "../../../types/Prisma";

// If does not exists before hand, generate a new one and return that instead.
export const retrieveExerciseMetadata = async (
  context: AppContext,
  exerciseName: string
): Promise<ExcerciseMetadata> => {
  const prisma = context.dataSources.prisma;
  const excerciseMetadata = await prisma.excerciseMetadata.findUnique({
    where: {
      user_id_excercise_name: {
        user_id: context.base_user!.User!.user_id,
        excercise_name: exerciseName,
      },
    },
  });

  if (excerciseMetadata) {
    return excerciseMetadata;
  } else {
    // generate a new one
    const metadata = await prisma.excerciseMetadata.create({
      data: {
        user_id: context.base_user!.User!.user_id,
        excercise_name: exerciseName,
      },
    });
    return metadata;
  }
};

// updates a excerciseMetadata with the stats of the completed workout if present
export async function updateExcerciseMetadataWithCompletedWorkout(
  context: AppContext,
  workout: WorkoutWithExerciseSets
) {
  // TODO: Refactor into progressive overload algo
  const prisma = context.dataSources.prisma;

  for (const excercise_group_set of workout.excercise_set_groups) {
    let oldMetadata = await prisma.excerciseMetadata.findUnique({
      where: {
        user_id_excercise_name: {
          user_id: context.base_user!.User!.user_id,
          excercise_name: excercise_group_set.excercise_name,
        },
      },
      include: {
        excercise: true,
      },
    });
    if (oldMetadata == null) {
      oldMetadata = await prisma.excerciseMetadata.create({
        data: {
          user_id: context.base_user!.User!.user_id,
          excercise_name: excercise_group_set.excercise_name,
        },
        include: {
          excercise: true,
        },
      });
    }

    // TODO: a way to select best set that takes into account both weight and rep
    let best_set = {
      actual_weight: oldMetadata.best_weight,
      actual_reps: oldMetadata.best_rep,
    };

    for (const excercise_set of excercise_group_set.excercise_sets) {
      if (oldMetadata.excercise.body_weight == true) {
        if (best_set.actual_reps < excercise_set.actual_reps!) {
          best_set = {
            actual_weight: excercise_set.actual_weight!,
            actual_reps: excercise_set.actual_reps!,
          };
        }
      } else {
        if (best_set.actual_weight < excercise_set.actual_weight!) {
          best_set = {
            actual_weight: excercise_set.actual_weight!,
            actual_reps: excercise_set.actual_reps!,
          };
        }
      }
    }

    await prisma.excerciseMetadata.update({
      where: {
        user_id_excercise_name: {
          user_id: context.base_user!.User!.user_id,
          excercise_name: excercise_group_set.excercise_name,
        },
      },
      data: {
        best_rep: best_set.actual_reps,
        best_weight: best_set.actual_weight,
        last_excecuted: new Date(),
      },
    });
  }
}
// Need to retest this function
// Generates excerciseMetadata if it's not available for any of the excercises in a workout
export async function generateOrUpdateExcerciseMetadata({
  context,
  excercise_metadatas,
  user_id,
}: {
  context: AppContext;
  excercise_metadatas: ExcerciseMetaDataInput[];
  user_id?: string;
}) {
  const prisma = context.dataSources.prisma;
  for (const excercise_metadata of excercise_metadatas) {
    delete excercise_metadata["last_excecuted"];
    const excerciseMetadata = await prisma.excerciseMetadata.findUnique({
      where: {
        user_id_excercise_name: {
          //There was some issue using this so I removed all of this =>(parseInt(user_id!) ?? context.base_user!.User!.user_id)
          user_id:
            user_id == undefined
              ? context.base_user!.User!.user_id
              : parseInt(user_id),
          excercise_name: excercise_metadata.excercise_name,
        },
      },
    });

    if (excerciseMetadata == null) {
      // create one with the excerciseMetadata provided
      await prisma.excerciseMetadata.create({
        data: {
          user_id:
            user_id == undefined
              ? context.base_user!.User!.user_id
              : parseInt(user_id),
          ...excercise_metadata,
        },
      });
    } else {
      // update the excerciseMetadata with provided ones
      await prisma.excerciseMetadata.update({
        where: {
          user_id_excercise_name: {
            user_id:
              user_id == undefined
                ? context.base_user!.User!.user_id
                : parseInt(user_id),
            excercise_name: excercise_metadata.excercise_name,
          },
        },
        data: {
          user_id:
            user_id == undefined
              ? context.base_user!.User!.user_id
              : parseInt(user_id),
          ...excercise_metadata,
        },
      });
    }
  }
}

/**
 * Generates Exercise metadata for the requestor, using @exercise_name
 * Note: function will skip if there is already one existing
 */
export async function generateExerciseMetadata(
  context: AppContext,
  exercise_name: string
) {
  await checkExerciseExists({ context, exercise_name });
  const prisma = context.dataSources.prisma;
  let excerciseMetadata = await prisma.excerciseMetadata.findUnique({
    where: {
      user_id_excercise_name: {
        user_id: context.base_user!.User!.user_id,
        excercise_name: exercise_name,
      },
    },
  });
  if (excerciseMetadata == null) {
    // create one with the excerciseMetadata provided
    excerciseMetadata = await prisma.excerciseMetadata.create({
      data: {
        user_id: context.base_user!.User!.user_id,
        excercise_name: exercise_name,
      },
    });
  }
}
