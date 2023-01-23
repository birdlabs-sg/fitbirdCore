import { AppContext } from "../../../types/contextType";
import { onlyCoach } from "../../../service/firebase/firebase_service";
import { QueryUsersArgs } from "../../../types/graphql";
import { GraphQLError } from "graphql";

export const usersQueryResolver = async (
  _: unknown,
  { coach_filters }: QueryUsersArgs,
  context: AppContext
) => {
  // Not exposing to the users for now.
  onlyCoach(context);
  if (coach_filters && !context.base_user?.coach?.coach_id) {
    throw new GraphQLError("Requestor is not a coach.");
  }
  const prisma = context.dataSources.prisma;

  return await prisma.user.findMany({
    where: {
      CoachClientRelationship: {
        some: {
          ...(coach_filters?.active != null && {
            active: coach_filters.active!,
          }),
          ...(coach_filters?.clients != null && {
            coach_id: context.base_user?.coach?.coach_id,
          }),
        },
      },
    },
  });
};
