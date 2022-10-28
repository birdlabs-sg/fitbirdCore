import { AppContext } from '../../../../types/contextType';
import { onlyCoach } from '../../../../service/firebase/firebase_service';

// find all users that are registered with the coach
export const coachUsersNotRegisteredQueryResolver = async (
  _: unknown,
  __: unknown,
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
