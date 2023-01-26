import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { QueryGetCoachClientRelationshipArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";
import { GraphQLError } from "graphql";
import { getStakeHoldersID } from "../utils";

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
  const stakeholderIds = getStakeHoldersID({
    context: context,
    user_id: user_id,
    coach_id: coach_id,
  });
  if (stakeholderIds.coach_id == null || stakeholderIds.user_id == null) {
    throw new GraphQLError("Both coach_id and user_id needs to be present");
  }
  const prisma = context.dataSources.prisma;
  return await prisma.coachClientRelationship.findUniqueOrThrow({
    where: {
      coach_id_user_id: {
        user_id: parseInt(stakeholderIds.user_id),
        coach_id: parseInt(stakeholderIds.coach_id),
      },
    },
  });
};
