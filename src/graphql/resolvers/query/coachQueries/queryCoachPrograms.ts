import { AppContext } from "../../../../types/contextType";

//find all programs associated with the coach
// must be protected
export const coachProgramsResolver = async (
    _: any,
    __: any,
    context: AppContext
  ) => {
    
    //onlyCoach(context);
    const prisma = context.dataSources.prisma;
    const programs = await prisma.program.findMany({
      where: {
        coach_id: context.coach.coach_id,
      },
    });    
    return programs;
  };
  