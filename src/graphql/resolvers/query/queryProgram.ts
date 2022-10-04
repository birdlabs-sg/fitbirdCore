import { AppContext } from "../../../types/contextType";
import {
  onlyAuthenticated,
  onlyCoach,
} from "../../../service/firebase/firebase_service";

// get the program with the associated coach_id
export const programQueryResolver = async (
  _: any,
  __: any,
  context: AppContext
) => {
  onlyAuthenticated(context);
  onlyCoach(context);
  const prisma = context.dataSources.prisma;
  return await prisma.program.findMany({
    where: {
      coach_id: context.coach.coach_id,
    },
  });
};
