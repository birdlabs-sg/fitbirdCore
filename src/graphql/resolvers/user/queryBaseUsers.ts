import { AppContext } from "../../../types/contextType";
import { onlyAdmin } from "../../../service/firebase/firebase_service";
export const baseUsersQueryResolver = async (
  _: unknown,
  __: unknown,
  context: AppContext
) => {
  onlyAdmin(context);
  const prisma = context.dataSources.prisma;
  return await prisma.baseUser.findMany({
    include: {
      coach: true,
      User: true,
    },
  });
};
