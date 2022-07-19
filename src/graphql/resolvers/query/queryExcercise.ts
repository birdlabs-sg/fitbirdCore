export const getExcerciseQueryResolver = async (
  parent: any,
  args: any,
  context: any,
  info: any
) => {
  const prisma = context.dataSources.prisma;

  return await prisma.excercise.findUnique({
    where: {
      excercise_name: args.excercise_name,
    },
  });
};
