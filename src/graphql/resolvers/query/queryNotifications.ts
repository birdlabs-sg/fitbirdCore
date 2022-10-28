import { AppContext } from "../../../types/contextType";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";

export const notificationsQueryResolver = async (
  _: unknown,
  __: unknown,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  return await prisma.notification.findMany({
    where: { user_id: context.base_user!.User!.user_id },
  });
};
