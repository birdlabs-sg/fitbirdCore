import gql from "graphql-tag";

export const Coach = gql`
  "Represents broadcast message to selected users."
  type Coach {
    coach_id: ID!
    Review: [Review!]
    Program: [Program!]
  }
`;
