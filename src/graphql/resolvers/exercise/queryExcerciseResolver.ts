import { QueryGetExcerciseArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";

export const getExcerciseQueryResolver = async (
  _: unknown,
  args: QueryGetExcerciseArgs,
  context: AppContext
) => {
  const prisma = context.dataSources.prisma;

  return await prisma.excercise.findUniqueOrThrow({
    where: {
      excercise_name: args.excercise_name,
    },
  });
};
