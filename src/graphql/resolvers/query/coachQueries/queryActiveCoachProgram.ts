import { AppContext } from "../../../../types/contextType";

import { onlyCoach } from "../../../../service/firebase/firebase_service";
import { QueryCoachActiveProgramArgs } from "../../../../types/graphql";
//find a specific program with the specified program_id
export const coachActiveProgramQueryResolver = async (
  _: any,
  args: QueryCoachActiveProgramArgs,
  context: AppContext
) => {
  onlyCoach(context);
  const { user_id } = args;
  const prisma = context.dataSources.prisma;
  const program = await prisma.program.findFirst({
    where: {
      coach_id: context.coach.coach_id,
      user_id: parseInt(user_id),
      is_active: true,
    },
    include: {
      workouts: true,
      
    },
  });
  return program;
};
