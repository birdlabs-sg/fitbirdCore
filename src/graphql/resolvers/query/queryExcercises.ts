export const excercisesQueryResolver = async (
  parent: any,
  args: any,
  context: any,
  info: any
) => {
  const prisma = context.dataSources.prisma;
  return await prisma.excercise.findMany();
};
