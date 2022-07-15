"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.WorkoutFrequency = void 0;
const { gql } = require("apollo-server");
exports.WorkoutFrequency = gql `
  "Represents a user. Contains meta-data specific to each user."
  type WorkoutFrequency {
    workout_count: Int!
    week_identifier: String
  }
`;
//# sourceMappingURL=workoutFrequency.js.map