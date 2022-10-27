import { AppContext } from "../../../types/contextType";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";

export const baseUserQueryResolver = async (
  _: any,
  __: any,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  return await prisma.baseUser.findUnique({
    where: {
      base_user_id: context.base_user?.base_user_id,
    },
    include: {
      coach: true,
      User: true,
    },
  });
};
