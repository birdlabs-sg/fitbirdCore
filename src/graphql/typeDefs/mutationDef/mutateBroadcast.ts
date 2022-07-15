const { gql } = require("apollo-server");

export const mutateBroadCast = gql`
  "Response if mutating a broadcast was successful"
  type mutateBroadcastResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    broadcast: BroadCast
  }

  type Mutation {
    "[PROTECTED:ADMIN ONLY] Creates a broadcast object."
    createBroadcast(
      broadcast_message: String!
      users: [ID!]
      scheduled_start: String!
      scheduled_end: String!
    ): mutateBroadcastResponse

    "[PROTECTED:ADMIN ONLY] Updates a broadcast object."
    updateBroadcast(
      broad_cast_id: ID!
      broadcast_message: String
      users: [Int]
      scheduled_start: String
      scheduled_end: String
    ): mutateBroadcastResponse

    "[PROTECTED:ADMIN ONLY] Deletes a broadcast object."
    deleteBroadcast(broad_cast_id: ID!): mutateBroadcastResponse
  }
`;
