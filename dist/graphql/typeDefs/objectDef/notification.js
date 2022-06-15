"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Notification = void 0;
const { gql } = require('apollo-server');
exports.Notification = gql `
  "Represents notification message for a specific user."
  type Notification {
        notification_id:  ID
        notification_message: String
        user_id: Int
    }
`;
//# sourceMappingURL=notification.js.map