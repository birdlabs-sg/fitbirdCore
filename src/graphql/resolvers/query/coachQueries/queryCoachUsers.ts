import { AppContext } from "../../../../types/contextType";
import { onlyCoach } from "../../../../service/firebase/firebase_service";
// finds all users that have programs with coach
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
            coach_id: context.base_user.coach!.coach_id,
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
