"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.mutatateGenerateIdToken = void 0;
const { gql } = require("apollo-server");
exports.mutatateGenerateIdToken = gql `
  "Represents a firebase id Token"
  type Token {
    kind: String!
    idToken: String!
    refreshToken: String!
    expiresIn: String!
    isNewUser: Boolean!
  }

  "Response if a token generation event is successful"
  type GenerateIdTokenResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    token: Token
  }

  "Mutation to generation an access token given a firebase uid. This is for testing purposes only."
  type Mutation {
    generateFirebaseIdToken(uid: String): GenerateIdTokenResponse
  }
`;
//# sourceMappingURL=mutateGenerateIdToken.js.map