import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { MutationUpdateClientCoachRelationshipArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";
import { GraphQLError } from "graphql";

/**
 * Updates a client-coach relationship specfied at @coach_id and @user_id
 *
 * NOTE:
 * Requestor's ID has to be either @coach_id or @user_id
 */
export const updateClientCoachRelationshipResolver = async (
  _: unknown,
  { coach_id, user_id, active }: MutationUpdateClientCoachRelationshipArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const requestor_id =
    context.base_user?.User?.user_id ?? context.base_user?.coach?.coach_id;
  if (!requestor_id) {
    throw new GraphQLError("Requestor does not have a valid id.");
  }
  if (requestor_id != parseInt(coach_id) && requestor_id != parseInt(user_id)) {
    throw new GraphQLError(
      "Requestor cannot create relationships that he does not belong in."
    );
  }
  const prisma = context.dataSources.prisma;
  const clientCoachRelationship = prisma.coachClientRelationship.update({
    where: {
      coach_id_user_id: {
        user_id: parseInt(user_id),
        coach_id: parseInt(coach_id),
      },
    },
    data: {
      active: active,
    },
  });
  return {
    code: "200",
    success: true,
    message: "Successfully updated your workout!",
    workouts: clientCoachRelationship,
  };
};