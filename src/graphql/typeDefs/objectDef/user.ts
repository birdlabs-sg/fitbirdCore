const { gql } = require("apollo-server");

export const User = gql`
  "Represents a user. Contains meta-data specific to each user."
  type User {
    user_id: ID!
    email: String
    displayName: String
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
    equipment_accessible: [Equipment]
  }
`;
