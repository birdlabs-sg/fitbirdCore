"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.mutateExcerciseMetadata = void 0;
const { gql } = require("apollo-server");
exports.mutateExcerciseMetadata = gql `
  "Response if mutating a excercise was successful"
  type mutateExcerciseMetaDataResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    excerciseMetadata: ExcerciseMetadata
  }

  type Mutation {
    "[PROTECTED] Creates a excerciseMetadata object."
    createExcerciseMetadata(
      excercise_id: ID!
      rest_time_lower_bound: Int!
      rest_time_upper_bound: Int!
      preferred: Boolean
      haveRequiredEquipment: Boolean
    ): mutateExcerciseMetaDataResponse

    "[PROTECTED] Updates a excerciseMetadata object."
    updateExcerciseMetadata(
      excercise_id: ID!
      rest_time_lower_bound: Int
      rest_time_upper_bound: Int
      preferred: Boolean
      haveRequiredEquipment: Boolean
    ): mutateExcerciseMetaDataResponse
  }
`;
//# sourceMappingURL=mutateExcerciseMetaData.js.map