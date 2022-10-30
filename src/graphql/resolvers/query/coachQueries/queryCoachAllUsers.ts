import { AppContext } from "../../../../types/contextType";
import { onlyCoach } from "../../../../service/firebase/firebase_service";
import { BaseUser } from "../../../../types/graphql";
// get all users
export const coachAllUsersQueryResolver = async (
  _: any,
  __: any,
  context: AppContext
) => {
  onlyCoach(context);
  const prisma = context.dataSources.prisma;

  const baseusers = await prisma.baseUser.findMany({
    include: {
      User: true
    }
  });

  return baseusers;
};
