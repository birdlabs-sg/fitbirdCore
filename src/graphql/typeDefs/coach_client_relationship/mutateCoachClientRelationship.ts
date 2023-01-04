import gql from "graphql-tag";

export const mutateCoachClientRelationship = gql`
  "Response if mutating a excercise was successful"
  type mutateCoachClientRelationship implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    client_coach_relationship: CoachClientRelationship
  }

  type Mutation {
    "[PROTECTED] Updates a excerciseMetadata object."
    deleteCoachClientRelationship(
      coach_id: ID!
      user_id: ID!
    ): mutateCoachClientRelationship

    updateCoachClientRelationship(
      coach_id: ID!
      user_id: ID!
      active: Boolean!
    ): mutateCoachClientRelationship

    createCoachClientRelationship(
      coach_id: ID!
      user_id: ID!
    ): mutateCoachClientRelationship
  }
`;
