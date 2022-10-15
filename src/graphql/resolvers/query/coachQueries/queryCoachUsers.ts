import { AppContext } from "../../../../types/contextType";
import { onlyCoach } from "../../../../service/firebase/firebase_service";
import { BaseUser } from "../../../../types/graphql";
// finds all users that have programs with coach
export const coachUsersQueryResolver = async (
  _: any,
  __: any,
  context: AppContext
) => {
  onlyCoach(context);
  console.log(context.coach);
  const prisma = context.dataSources.prisma;
  const users = await prisma.program.findMany({
    where: {
      coach_id: context.coach.coach_id,
      is_active:true
    },
  });

  const baseusers = await prisma.baseUser.findMany({
    where: {
      User: {
        user_id: {
          in: users.map((user) => user.user_id),
        },
      },
    },
    include: {
      User: true,
    },
  });

  return baseusers;
};
