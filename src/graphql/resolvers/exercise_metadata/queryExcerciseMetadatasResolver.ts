import { QueryGetExcerciseMetadatasArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";

export const getExcerciseMetadatasQueryResolver = async (
  _: unknown,
  args: QueryGetExcerciseMetadatasArgs,
  context: AppContext
) => {
  const prisma = context.dataSources.prisma;
  const { excercise_names_list } = args;
  return await prisma.excerciseMetadata.findMany({
    where: {
      user_id: context.base_user?.User?.user_id,
      excercise_name: {
        in: excercise_names_list[0],
      },
    },
  });
};
