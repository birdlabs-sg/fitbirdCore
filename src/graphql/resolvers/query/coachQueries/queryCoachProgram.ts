
import { AppContext } from "../../../../types/contextType";
import { QueryCoachProgramArgs } from "../../../../types/graphql";
import { onlyCoach } from "../../../../service/firebase/firebase_service";
//find a specific program with the specified program_id
//must be protected
export const coachProgramQueryResolver = async (
    _: any,
    args: QueryCoachProgramArgs,
    context: AppContext
  ) => {
    onlyCoach(context);
    const {program_id} = args
    const prisma = context.dataSources.prisma;
    const programs = await prisma.program.findFirst({
      where: {
        program_id:parseInt(program_id)
      },
      include:{
        workouts:true
      }
    });    
    return programs;
  };