
import { AppContext } from "../../../../types/contextType";
import { QueryCoachProgramArgs } from "../../../../types/graphql";
//find a specific program with the specified program_id
//must be protected
export const coachProgramResolver = async (
    _: any,
    args: QueryCoachProgramArgs,
    context: AppContext
  ) => {
    //onlyCoach(context);
    const {program_id} = args
    const prisma = context.dataSources.prisma;
    const programs = await prisma.program.findFirst({
      where: {
        program_id:parseInt(program_id)
      },
    });    
    return programs;
  };