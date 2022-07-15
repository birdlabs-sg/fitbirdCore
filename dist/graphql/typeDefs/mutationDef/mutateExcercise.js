"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.mutateExcercise = void 0;
const { gql } = require("apollo-server");
exports.mutateExcercise = gql `
  "Response if mutating a excercise was successful"
  type mutateExcerciseResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    excercise: Excercise
  }

  type Mutation {
    "[PROTECTED:ADMIN ONLY] Creates a excercise object."
    createExcercise(
      excercise_name: String!
      excercise_preparation: String!
      excercise_instructions: String!
      target_regions: [Int]
      stabilizer_muscles: [Int]
      synergist_muscles: [Int]
      dynamic_stabilizer_muscles: [Int]
    ): mutateExcerciseResponse

    "[PROTECTED:ADMIN ONLY] Updates a excercise object."
    updateExcercise(
      excercise_id: ID!
      excercise_name: String
      excercise_preparation: String
      excercise_instructions: String
      target_regions: [Int]
      stabilizer_muscles: [Int]
      synergist_muscles: [Int]
      dynamic_stabilizer_muscles: [Int]
    ): mutateExcerciseResponse

    "[PROTECTED:ADMIN ONLY] Deletes a excercise object."
    deleteExcercise(excercise_id: ID!): mutateExcerciseResponse
  }
`;
//# sourceMappingURL=mutateExcercise.js.map