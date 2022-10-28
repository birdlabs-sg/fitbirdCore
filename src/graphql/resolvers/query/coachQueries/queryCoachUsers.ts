import { AppContext } from "../../../../types/contextType";
import { onlyCoach } from "../../../../service/firebase/firebase_service";
// finds all users that have programs with coach => may not have an active one so coaches can see it as well
export const coachUsersQueryResolver = async (
  _: any,
  __: any,
  context: AppContext
) => {
  onlyCoach(context);
  const prisma = context.dataSources.prisma;

  const baseusers = await prisma.baseUser.findMany({
    where: {
      User: {
        Program: {
          some: {
            coach_id: context.coach.coach_id,
          },
        },
      },
    },
    include: {
      User: true,
    },
  });

  return baseusers;
};
