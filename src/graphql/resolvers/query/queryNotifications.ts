import { AppContext } from "../../../types/contextType";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";

export const notificationsQueryResolver = async (
  _: any,
  __: any,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  return await prisma.notification.findMany({
    where: { user_id: context.user.user_id },
  });
};
