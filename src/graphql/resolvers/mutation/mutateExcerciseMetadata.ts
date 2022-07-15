import {
  onlyAuthenticated,
  onlyAdmin,
} from "../../../service/firebase_service";

export const createExcerciseMetadata = async (
  _: any,
  args: any,
  context: any
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const { excercise_id, ...otherArgs } = args;

  const newExcerciseMetadata = await prisma.excerciseMetadata.create({
    data: {
      ...otherArgs,
      excercise: {
        connect: { excercise_id: parseInt(excercise_id) },
      },
      user: {
        connect: { user_id: context.user.user_id },
      },
    },
  });
  return {
    code: "200",
    success: true,
    message: "Successfully created an excercise metadata!",
    excercise: newExcerciseMetadata,
  };
};

export const updateExcerciseMetadata = async (
  _: any,
  args: any,
  context: any
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const { excercise_id, ...otherArgs } = args;

  const updatedExcerciseMetadata = await prisma.excerciseMetadata.update({
    where: {
      user_id_excercise_id: {
        user_id: context.user.user_id,
        excercise_id: parseInt(excercise_id),
      },
    },
    data: {
      ...otherArgs,
    },
  });

  return {
    code: "200",
    success: true,
    message: "Successfully updated the specified excercise metadata!",
    excerciseMetadata: updatedExcerciseMetadata,
  };
};
