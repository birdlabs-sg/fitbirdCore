
import { onlyCoach } from "../../../../service/firebase/firebase_service";
import { AppContext } from "../../../../types/contextType";

export const coachPresetsQueryResolver = async (
  _: unknown,
  __: unknown,
  context: AppContext
) => {
  
  onlyCoach(context)
  const prisma = context.dataSources.prisma;

  return await prisma.programPreset.findMany({
    where: {
     coach_id:context.base_user.coach.coach_id
    },
   
  });
};
