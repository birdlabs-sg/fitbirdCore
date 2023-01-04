import { MutationCreateCoachClientRelationshipArgs } from "../../../types/graphql";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
// import { MutationCreateClientCoachRelationshipArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";
import { GraphQLError } from "graphql";

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
  const clientCoachRelationship = await prisma.coachClientRelationship.create({
    data: {
      user_id: parseInt(user_id),
      coach_id: parseInt(coach_id),
    },
  });
  return {
    code: "200",
    success: true,
    message: "Successfully created client-coach relationship!",
    client_coach_relationship: clientCoachRelationship,
  };
};
