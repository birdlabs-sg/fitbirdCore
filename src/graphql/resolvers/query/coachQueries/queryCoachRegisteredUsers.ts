import { AppContext } from "../../../../types/contextType";
import { onlyCoach } from "../../../../service/firebase/firebase_service";
import { QueryCoachRegisteredUsersArgs } from "../../../../types/graphql";
// finds all users that have programs with coach AND registered with coach => may not have an active one so coaches can see it as well
export const coachRegisteredUsersQueryResolver = async (
  _: unknown,
  args: QueryCoachRegisteredUsersArgs,
  context: AppContext
) => {
  onlyCoach(context);
  const prisma = context.dataSources.prisma;
  const { filter } = args;
  switch (filter) {
    case "ACTIVE":
      return await prisma.baseUser.findMany({
        where: {
          User: {
            Program: {
              some: {
                coach_id: context.base_user!.coach!.coach_id,
                is_active:true
              },
            },
          },
        },
        include: {
          User: true,
        },
      });
      case "NONE":
        return await prisma.baseUser.findMany({
          where: {
            User: {
              Program: {
                some: {
                  coach_id: context.base_user!.coach!.coach_id,
                },
              },
            },
          },
          include: {
            User: true,
          },
        });
        
  }
};
