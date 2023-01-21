import { MutationCreateCoachClientRelationshipArgs } from "../../../types/graphql";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
// import { MutationCreateClientCoachRelationshipArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";
import { GraphQLError } from "graphql";
import { getStakeHoldersID } from "../utils";

/**
 * Creates a client-coach relationship
 *
 * NOTE:
 * Requestor's ID has to be either @coach_id or @user_id
 */
export const createCoachClientRelationshipResolver = async (
  _: unknown,
  { coach_id, user_id }: MutationCreateCoachClientRelationshipArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const stakeholderIds = getStakeHoldersID({
    context: context,
    user_id: user_id,
    coach_id: coach_id,
  });
  if (stakeholderIds.coach_id == null || stakeholderIds.user_id == null) {
    throw new GraphQLError("Both coach_id and user_id needs to be present");
  }

  const prisma = context.dataSources.prisma;
  const clientCoachRelationship = await prisma.coachClientRelationship.create({
    data: {
      user_id: parseInt(stakeholderIds.user_id),
      coach_id: parseInt(stakeholderIds.coach_id)!,
    },
  });
  return {
    code: "200",
    success: true,
    message: "Successfully created client-coach relationship!",
    client_coach_relationship: clientCoachRelationship,
  };
};
