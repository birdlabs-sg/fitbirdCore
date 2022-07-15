"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ExcerciseMetadata = void 0;
const { gql } = require("apollo-server");
exports.ExcerciseMetadata = gql `
  "Represents a logical component of a workout session."
  type ExcerciseMetadata {
    excercise_id: ID!
    haveRequiredEquipment: Boolean
    preferred: Boolean
    rest_time_lower_bound: Int!
    rest_time_upper_bound: Int!
  }
`;
//# sourceMappingURL=exerciseMetadata.js.map