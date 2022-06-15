"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.mutateBroadCast = void 0;
const { gql } = require('apollo-server');
exports.mutateBroadCast = gql `
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
            broadcast_message:String!,
            users:[Int!],
            scheduled_start:String!,
            scheduled_end:String!,
            )
        : mutateBroadcastResponse

        "[PROTECTED:ADMIN ONLY] Updates a broadcast object."
        updateBroadcast(
            broad_cast_id:Int!,
            broadcast_message:String,
            users:[Int],
            scheduled_start:String,
            scheduled_end:String,
        )
        : mutateBroadcastResponse

        "[PROTECTED:ADMIN ONLY] Deletes a broadcast object."
        deleteBroadcast(
            broad_cast_id:Int!,
        )
        : mutateBroadcastResponse
    }
`;
//# sourceMappingURL=mutateBroadcast.js.map