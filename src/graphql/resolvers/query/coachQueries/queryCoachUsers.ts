import { AppContext } from "../../../../types/contextType";
import { onlyCoach } from "../../../../service/firebase/firebase_service";
import { BaseUser } from "../../../../types/graphql";
// fina all users that are registered with the coach
export const coachUsersQueryResolver = async (
  _: any,
  __: any,
  context: AppContext
) => {
  //onlyCoach(context);
  const prisma = context.dataSources.prisma;
  const users = await prisma.program.findMany({
    where: {
      coach_id: context.coach.coach_id,
    },
  });
  let userIdArr: number[] = [];
  for (let user = 0; user < users.length; user++) {
    userIdArr[user[0].user_id];
  }

  const baseusers = await prisma.baseUser.findMany({
    where: {
      AND: [
        {
          coach: {
            coach_id: context.coach.coach_id,
          },
        },
        {
          User: {
            user_id: {
              in: userIdArr.map((i) => i),
            },
          },
        },
      ],
    },
    include: {
      User: true,
    },
  });

  return baseusers;
};
