const { gql } = require('apollo-server');

export const Notification = gql`
  "Represents notification message for a specific user."
  type Notification {
        notification_id:  ID
        notification_message: String
        user_id: Int
    }
`;