import { AppContext } from "../../../../types/contextType";
import { onlyCoach } from "../../../../service/firebase/firebase_service";
import { BaseUser } from "../../../../types/graphql";
// find all users that are registered with the coach
export const coachUsersNotRegisteredQueryResolver = async (
  _: any,
  __: any,
  context: AppContext
) => {
  onlyCoach(context);
  const prisma = context.dataSources.prisma;

  const baseusers = await prisma.baseUser.findMany({
    include:{
      User:true
    }
  });

  return baseusers;
};
