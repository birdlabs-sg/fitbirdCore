import { AppContext } from "../../../types/contextType";
import {
  onlyAdmin,
  onlyAuthenticated,
  onlyCoach,
} from "../../../service/firebase/firebase_service";
import { QueryProgramArgs } from "../../../types/graphql";
// get the program with the associated coach_id
export const programQueryResolver = async (
  _: any,
  __: any,
  context: AppContext
) => {
  onlyAdmin(context)
  const prisma = context.dataSources.prisma;
  return await prisma.program.findMany({});
};

