import { AppContext } from "../../../../types/contextType";
import { onlyCoach } from "../../../../service/firebase/firebase_service";
import { BaseUser } from "../../../../types/graphql";
// fina all users that are registered with the coach
export const coachUsersNotRegisteredQueryResolver = async (
  _: any,
  __: any,
  context: AppContext
) => {
  onlyCoach(context);
  const prisma = context.dataSources.prisma;
  const users = await prisma.program.findMany({
    where: {
      coach_id: context.coach.coach_id,
      is_active: true,
    },
  });

  const baseusers = await prisma.baseUser.findMany({
    where: {
      NOT: {
        User: {
          user_id: {
            in: users.map((user) => user.user_id),
          },
        },
      },
    },
  });

  return baseusers;
};
