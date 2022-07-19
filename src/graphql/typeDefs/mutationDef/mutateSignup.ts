const { gql } = require("apollo-server");

export const mutateSignup = gql`
  "Response if a signup event is successful"
  type SignupResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
  }

  "[PUBLIC] Mutation to create a new user within firebase and postgresql."
  type Mutation {
    signup(
      email: String!
      phoneNumber: String
      password: String!
      displayName: String!
    ): SignupResponse
  }
`;
