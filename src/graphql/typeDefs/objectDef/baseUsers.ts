const { gql } = require("apollo-server");

export const BaseUsers = gql`
  "Represents a user. Contains meta-data specific to each user."
  type BaseUsers {
    base_user_id: ID!
    email: String
    displayName: String
  }
`;
