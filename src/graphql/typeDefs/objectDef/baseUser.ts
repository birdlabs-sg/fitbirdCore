const { gql } = require("apollo-server");

export const BaseUser = gql`
  "Represents a user. Contains meta-data specific to each user."
  type BaseUser {
    base_user_id: ID!
    email: String
    displayName: String
    coach: Coach
    User: User
  }
`;
