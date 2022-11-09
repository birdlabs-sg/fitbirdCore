import { AppContext } from "../../../types/contextType";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { onlyAdmin } from "../../../service/firebase/firebase_service";
export const usersQueryResolver = async (
  _: unknown,
  __: unknown,
  context: AppContext
) => {
  onlyAuthenticated(context);
  onlyAdmin(context);
  const prisma = context.dataSources.prisma;
  // reject non admins. Exception will be thrown if not
  return await prisma.user.findMany();
};
