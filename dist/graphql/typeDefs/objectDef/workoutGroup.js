"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.WorkoutGroup = void 0;
const { gql } = require("apollo-server");
exports.WorkoutGroup = gql `
  "Represents a user. Contains meta-data specific to each user."
  type WorkoutGroup {
    workout_group_id: ID!
    workout_group_name: String!
    life_span: Int!
  }
`;
//# sourceMappingURL=workoutGroup.js.map