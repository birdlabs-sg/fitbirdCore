import { AppContext } from "../../../types/contextType";

export const presetsQueryResolver = async (
  _: unknown,
  __: unknown,
  context: AppContext
) => {
  const prisma = context.dataSources.prisma;

  return await prisma.challengePreset.findMany({});
};
