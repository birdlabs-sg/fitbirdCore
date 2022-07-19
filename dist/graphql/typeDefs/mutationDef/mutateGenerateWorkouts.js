"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.mutateGenerateWorkouts = void 0;
const { gql } = require("apollo-server");
exports.mutateGenerateWorkouts = gql `
  "Mutation to generate a set of workouts"
  type Mutation {
    generateWorkouts(no_of_workouts: Int!): [Workout]
  }
`;
//# sourceMappingURL=mutateGenerateWorkouts.js.map