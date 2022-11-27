import gql from "graphql-tag";

export const mutateChallenge = gql`
  "Response if a mutation event is successful"
  type ChallengeResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    user: Challenge
  }

  "[PROTECTED] [USER] Mutation to create a challengePreset"
  type Mutation {
    createChallenge(
       presetPreset_id:ID!
    ):ChallengeResponse
  }
`;
