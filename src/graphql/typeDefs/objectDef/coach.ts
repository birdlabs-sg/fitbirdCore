const { gql } = require("apollo-server");

export const Coach = gql`
  "Represents broadcast message to selected users."
  type Coach {
    coach_id: ID!
    email: String!
    firebase_uid: String!
    displayName: String!
    Review: [Review]!
    Program: [Program]!
  }
`;
