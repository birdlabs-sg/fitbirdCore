import gql from "graphql-tag";

export const Notification = gql`
  "Represents notification message for a specific user."
  type Notification {
    notification_id: ID!
    notification_message: String
    user_id: Int
  }
`;
