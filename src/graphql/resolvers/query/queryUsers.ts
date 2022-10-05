import { AppContext } from "../../../types/contextType";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import {
  onlyAdmin,
  onlyCoach,
} from "../../../service/firebase/firebase_service";
import { QueryProgramArgs } from "../../../types/graphql";
export const usersQueryResolver = async (
  _: any,
  __: any,
  context: AppContext
) => {
  onlyAuthenticated(context);
  onlyAdmin(context);
  const prisma = context.dataSources.prisma;
  // reject non admins. Exception will be thrown if not
  // const requester_user_id = context.user_id
  return await prisma.user.findMany();
};

