const { gql } = require("apollo-server");
export const mutateProgram = gql`
type mutateProgramResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    program: Program
  }
type Mutation {
"[PROTECTED] Creates a program object."
    createProgram(
        user_id: ID!
        workouts: [Workout!]
    ):mutateProgramResponse
  }
`;
