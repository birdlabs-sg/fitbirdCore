export const getExcerciseMetadatasQueryResolver = async (
  parent: any,
  args: any,
  context: any,
  info: any
) => {
  const prisma = context.dataSources.prisma;
  const { excercise_names_list } = args;
  return await prisma.excerciseMetadata.findMany({
    where: {
      user_id: context.user.user_id,
      excercise_name: {
        in: excercise_names_list[0],
      },
    },
  });
};
