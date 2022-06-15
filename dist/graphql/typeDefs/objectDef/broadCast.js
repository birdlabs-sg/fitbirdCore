"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.BroadCast = void 0;
const { gql } = require('apollo-server');
exports.BroadCast = gql `
    "Represents broadcast message to selected users."
    type BroadCast {
        broad_cast_id:  ID
        broadcast_message: String
        users: [User]
        scheduled_start: String
        scheduled_end:  String
    }
`;
//# sourceMappingURL=broadCast.js.map