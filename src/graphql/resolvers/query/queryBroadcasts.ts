import { onlyAuthenticated } from "../../../service/firebase_service";

export const broadCastsQueryResolver = async (
  parent: any,
  args: any,
  context: any,
  info: any
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  return await prisma.broadCast.findMany({
    where: {
      users: {
        some: {
          user_id: context.user_id,
        },
      },
    },
  });
};
