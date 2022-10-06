import { AppContext } from "../../../../types/contextType";
import { QueryCoachUserInfoArgs } from "../../../../types/graphql";

// find a specific user that is a member of the coach
export const coachUserInfoQueryResolver = async (
  _: any,
  args: QueryCoachUserInfoArgs,
  context: AppContext
) => {
  //onlyCoach(context);
  const prisma = context.dataSources.prisma;
  const { user_id } = args;

  const userDetails = await prisma.baseUser.findFirstOrThrow({
    where: {
      User: {
        user_id: parseInt(user_id),
      },
    },
    include: {
      User: true,
    },
  });
  return userDetails;
};
