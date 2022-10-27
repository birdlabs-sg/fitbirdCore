import { AppContext } from "../../../../types/contextType";
import { onlyCoach } from "../../../../service/firebase/firebase_service";
//find all programs associated with the coach
// must be protected
export const coachProgramsQueryResolver = async (
  _: any,
  __: any,
  context: AppContext
) => {
  onlyCoach(context);
  const prisma = context.dataSources.prisma;
  const programs = await prisma.program.findMany({
    where: {
      coach_id: context.base_user!.coach!.coach_id,
    },
  });
  return programs;
};
