import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { MutationCreateCoachClientRelationshipArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";
import { GraphQLError } from "graphql";
import { getStakeHoldersID } from "../utils";

/**
 * Deletes a client-coach relationship specfied at @coach_id and @user_id
 *
 * NOTE:
 * Requestor's ID has to be either @coach_id or @user_id
 */
export const deleteCoachClientRelationshipResolver = async (
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
  const clientCoachRelationship = await prisma.coachClientRelationship.delete({
    where: {
      coach_id_user_id: {
        user_id: parseInt(stakeholderIds.user_id),
        coach_id: parseInt(stakeholderIds.coach_id),
      },
    },
  });
  return {
    code: "200",
    success: true,
    message: "Successfully updated your workout!",
    client_coach_relationship: clientCoachRelationship,
  };
};
