import { AppContext } from "../../../types/contextType";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";

export const broadCastsQueryResolver = async (
  _: unknown,
  __: unknown,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  return await prisma.broadCast.findMany({
    where: {
      users: {
        some: {
          user_id: context.base_user!.User!.user_id,
        },
      },
    },
  });
};
