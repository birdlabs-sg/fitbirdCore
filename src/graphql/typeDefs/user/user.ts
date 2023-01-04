import gql from "graphql-tag";

export const User = gql`
  "Represents a user. Contains meta-data specific to each user."
  type User {
    user_id: ID!
    prior_years_of_experience: Float
    level_of_experience: LevelOfExperience
    age: Int
    dark_mode: Boolean
    workout_frequency: Int
    workout_duration: Int
    goal: Goal
    gender: Gender
    weight: Float
    height: Float
    weight_unit: WeightUnit
    height_unit: LengthUnit
    phoneNumber: String
    compound_movement_rep_lower_bound: Int
    compound_movement_rep_upper_bound: Int
    isolated_movement_rep_lower_bound: Int
    isolated_movement_rep_upper_bound: Int
    body_weight_rep_lower_bound: Int
    body_weight_rep_upper_bound: Int
    current_program_enrollment_id: Int
    base_user_id: Int!
    use_rpe: Boolean!
    signup_date: Date!
    equipment_accessible: [Equipment!]
    measurements: [Measurement!]
    notifications: [Notification!]
    broadcasts: [BroadCast!]
    excerciseMetadata: [ExcerciseMetadata!]
    program: [Program!]
    selected_exercise_for_analytics: [Excercise!]
  }
`;
