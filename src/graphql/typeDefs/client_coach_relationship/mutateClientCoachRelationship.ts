import gql from "graphql-tag";

export const mutateClientCoachRelationship = gql`
  "Response if mutating a excercise was successful"
  type mutateClientCoachRelationship implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    client_coach_relationship: ClientCoachRelationship
  }

  type Mutation {
    "[PROTECTED] Updates a excerciseMetadata object."
    deleteClientCoachRelationship(
      coach_id: ID!
      user_id: ID!
    ): mutateClientCoachRelationship

    updateClientCoachRelationship(
      coach_id: ID!
      user_id: ID!
      active: Boolean!
    ): mutateClientCoachRelationship

    createClientCoachRelationship(
      coach_id: ID!
      user_id: ID!
    ): mutateClientCoachRelationship
  }
`;
