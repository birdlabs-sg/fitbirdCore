"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.mutateNotification = void 0;
const { gql } = require("apollo-server");
exports.mutateNotification = gql `
  "Response if a signup event is successful"
  type NotificationResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
  }

  "[PUBLIC] Mutation to create a new notification with firebase"
  type Mutation {
    generateNotification(
      token: String!
      title: String!
      body: String!
    ): NotificationResponse
  }
`;
//# sourceMappingURL=mutateNotification.js.map