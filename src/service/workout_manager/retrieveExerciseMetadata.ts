// Retreives the user's exerciseMetadata with respect to the specified exercise.

import { ExcerciseMetadata } from "@prisma/client";

// If does not exists before hand, generate a new one and return that instead.
export const retrieveExerciseMetadata = async (
  context: any,
  exerciseName: String
): Promise<ExcerciseMetadata> => {
  const prisma = context.dataSources.prisma;
  const excerciseMetadata = await prisma.excerciseMetadata.findUnique({
    where: {
      user_id_excercise_name: {
        user_id: context.user.user_id,
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
        user_id: context.user.user_id,
        excercise_name: exerciseName,
      },
    });
    return metadata;
  }
};
