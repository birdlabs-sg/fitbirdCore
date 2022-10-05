import { QueryProgramArgs } from "../../../../types/graphql";
import { AppContext } from "../../../../types/contextType";

//find a specific program with the specified program_id
//must be protected
export const coachProgramResolver = async (
    _: any,
    args: QueryProgramArgs,
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