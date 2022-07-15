"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ExcercisePerformance = void 0;
const { gql } = require("apollo-server");
exports.ExcercisePerformance = gql `
  type GroupedExcerciseSets {
    date_completed: String
    excercise_sets: [ExcerciseSet]
  }
  type ExcercisePerformance {
    grouped_excercise_sets: [GroupedExcerciseSets]
  }
`;
//# sourceMappingURL=excercisePerformance.js.map