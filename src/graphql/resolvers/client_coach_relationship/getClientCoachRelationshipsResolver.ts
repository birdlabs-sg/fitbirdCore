import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { AppContext } from "../../../types/contextType";
import { GraphQLError } from "graphql";

/**
 * Retrieves client-coach relationships specfied from the requestor
 *
 */
export const getCoachClientRelationshipsResolver = async (
  _: unknown,
  __: unknown,
  context: AppContext
) => {
  onlyAuthenticated(context);
  if (
    !context.base_user?.User?.user_id &&
    !context.base_user?.coach?.coach_id
  ) {
    throw new GraphQLError(
      "Requestor does not have a valid coach_id or user_id"
    );
  }
  const prisma = context.dataSources.prisma;
  return await prisma.coachClientRelationship.findMany({
    where: {
      ...(context.base_user?.coach?.coach_id && {
        coach_id: context.base_user?.coach?.coach_id,
      }),
      ...(context.base_user?.User?.user_id && {
        user_id: context.base_user?.User?.user_id,
      }),
    },
  });
};
