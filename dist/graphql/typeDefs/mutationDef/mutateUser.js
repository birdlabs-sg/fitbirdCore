"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.mutateUser = void 0;
const { gql } = require("apollo-server");
exports.mutateUser = gql `
  "Response if a mutation event is successful"
  type MutateUserResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    user: User
  }

  "[PROTECTED] Mutation to update the requestor's user information"
  type Mutation {
    updateUser(
      gender: Gender
      weight: Float
      height: Float
      weight_unit: WeightUnit
      height_unit: LengthUnit
      prior_years_of_experience: Float
      level_of_experience: LevelOfExperience
      age: Int
      dark_mode: Boolean
      goal: Goal
      workout_frequency: Int
      workout_duration: Int
      automatic_scheduling: Boolean
      compound_movement_rep_lower_bound: Int
      compound_movement_rep_upper_bound: Int
      isolated_movement_rep_lower_bound: Int
      isolated_movement_rep_upper_bound: Int
    ): MutateUserResponse
  }
`;
//# sourceMappingURL=mutateUser.js.map