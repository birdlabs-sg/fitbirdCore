// Guards resolvers that can be accessed by both user and coaches.

import { GraphQLError } from "graphql";
import { AppContext } from "../../../types/contextType";

/**
 *  Guards a resolver
 *
 *  Note:
 * 1. Requestor's ID must match either user_id or coach_id
 * 2. If coach_id is present, will check if the relationship exists between user_id and coach_id.
 * 3. onlyAllowActiveRelationship only works if checkRelationship is true
 */
export const clientCoachRelationshipGuard = async ({
  context,
  user_id,
  coach_id,
  checkRelationship = false,
  onlyAllowActiveRelationship = false,
}: {
  context: AppContext;
  user_id: number;
  coach_id: number | null;
  checkRelationship: boolean;
  onlyAllowActiveRelationship: boolean;
}) => {
  // Must match either user_id or coach_id
  const requestor_id =
    context.base_user?.User?.user_id ?? context.base_user?.coach?.coach_id;
  if (!requestor_id) {
    throw new GraphQLError("Requestor has no user_id or coach_id.");
  }
  if (requestor_id != user_id && requestor_id != coach_id) {
    throw new GraphQLError(
      "Requestor ID did not match given user_id nor coach_id"
    );
  }
  if (!coach_id) {
    // skip checks if coach_id not present
    return;
  }
  if (!checkRelationship) {
    // skip relationship check
    return;
  }
  const coachClientRelationship =
    await context.dataSources.prisma.coachClientRelationship.findUnique({
      where: {
        coach_id_user_id: {
          user_id: user_id,
          coach_id: coach_id,
        },
      },
    });
  if (!coachClientRelationship) {
    throw new GraphQLError("Coach client relationship does not exist.");
  }
  if (onlyAllowActiveRelationship && coachClientRelationship.active) {
    throw new GraphQLError("Coach client relationship is not active.");
  }
};
