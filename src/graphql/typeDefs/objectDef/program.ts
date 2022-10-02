const { gql } = require("apollo-server");

export const Program = gql`
  "Represents broadcast message to selected users."
  type Program {
    program_id: ID!
    email: String!
    user: User!
    workouts: [Workout]!
  }
`;
