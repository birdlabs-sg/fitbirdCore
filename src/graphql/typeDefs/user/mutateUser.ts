import gql from "graphql-tag";

export const mutateUser = gql`
  "Response if a mutation event is successful"
  type MutateUserResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    user: User
  }

  input ExcerciseInput {
    excercise_name: String!
  }

  "[PROTECTED] Mutation to update the requestor's user information"
  type Mutation {
    updateUser(
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
      use_rpe: Boolean
      equipment_accessible: [Equipment!]
      selected_exercise_for_analytics: [ExcerciseInput!]
    ): MutateUserResponse
  }
`;
