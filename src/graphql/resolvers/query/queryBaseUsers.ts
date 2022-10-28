import { AppContext } from "../../../types/contextType";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
export const baseUsersQueryResolver = async (
  _: any,
  __: any,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  // reject non coaches. Exception will be thrown if not
  // const requester_user_id = context.user_id

  return await prisma.baseUser.findMany({
    include: {
      coach: true,
      User: true,
    },
  });
};
