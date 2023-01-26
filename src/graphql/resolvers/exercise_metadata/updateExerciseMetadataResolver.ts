import { AppContext } from "../../../types/contextType";
import { MutationUpdateExcerciseMetadataArgs } from "../../../types/graphql";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";

export const updateExerciseMetadataResolver = async (
  _: unknown,
  args: MutationUpdateExcerciseMetadataArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const { excercise_name, ...otherArgs } = args;

  const updatedExcerciseMetadata = await prisma.excerciseMetadata.update({
    where: {
      user_id_excercise_name: {
        user_id: context.base_user!.User!.user_id,
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
