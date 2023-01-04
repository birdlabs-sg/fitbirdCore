import gql from "graphql-tag";

export const BaseUser = gql`
  type FCMToken {
    token: String
    date_issued: Date
  }

  "Represents a user. Contains meta-data specific to each user."
  type BaseUser {
    base_user_id: ID!
    email: String
    firebase_uid: String
    displayName: String
    coach: Coach
    user: User
    fcm_tokens: [FCMToken!]
  }
`;
