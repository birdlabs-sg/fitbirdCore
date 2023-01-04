import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { QueryGetCoachClientRelationshipArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";
import { GraphQLError } from "graphql";
import { clientCoachRelationshipGuard } from "../program/utils";

/**
 * Retrieves client-coach relationships specfied at @coach_id or @user_id
 *
 * NOTE:
 * Requestor's ID has to be either @coach_id or @user_id
 */
export const getCoachClientRelationshipResolver = async (
  _: unknown,
  { user_id, coach_id }: QueryGetCoachClientRelationshipArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  if (!coach_id && !user_id) {
    throw new GraphQLError("Need to pass in at least coach_id OR user_id");
  }
  await clientCoachRelationshipGuard({
    context,
    user_id: parseInt(user_id),
    coach_id: parseInt(user_id),
    checkRelationship: true,
    onlyAllowActiveRelationship: false,
  });
  const prisma = context.dataSources.prisma;
  return await prisma.coachClientRelationship.findUniqueOrThrow({
    where: {
      coach_id_user_id: {
        user_id: parseInt(user_id),
        coach_id: parseInt(user_id),
      },
    },
  });
};
