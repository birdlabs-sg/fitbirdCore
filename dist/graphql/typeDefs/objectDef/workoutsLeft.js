"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.WorkoutsLeft = void 0;
const { gql } = require("apollo-server");
exports.WorkoutsLeft = gql `
  "Represents a user. Contains meta-data specific to each user."
  type workoutsLeft {
    workouts_left: Int!
  }
`;
//# sourceMappingURL=workoutsLeft.js.map