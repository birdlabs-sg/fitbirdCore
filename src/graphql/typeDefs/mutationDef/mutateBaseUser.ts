import gql from "graphql-tag";

export const mutateBaseUser = gql`
  "Response if a mutation event is successful"
  type MutateBaseUserResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    user: BaseUser
  }

  "[PROTECTED] Mutation to update the requestor's user information"
  type Mutation {
    updateBaseUser(
      email: String
      displayName: String
      fcm_tokens: [String]
    ): MutateBaseUserResponse
  }
`;
