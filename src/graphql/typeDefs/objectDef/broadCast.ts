const { gql } = require("apollo-server");

export const BroadCast = gql`
  "Represents broadcast message to selected users."
  type BroadCast {
    broad_cast_id: ID!
    broadcast_message: String
    users: [User]
    scheduled_start: String
    scheduled_end: String
  }
`;
