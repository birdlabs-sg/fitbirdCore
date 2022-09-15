import { onlyAuthenticated } from "../../../service/firebase_service";

export const updateExcerciseMetadata = async (
  _: any,
  args: any,
  context: any
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const { excercise_name, ...otherArgs } = args;

  const updatedExcerciseMetadata = await prisma.excerciseMetadata.update({
    where: {
      user_id_excercise_name: {
        user_id: context.user.user_id,
        excercise_name: excercise_name,
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
    excercise_metadata: updatedExcerciseMetadata,
  };
};
