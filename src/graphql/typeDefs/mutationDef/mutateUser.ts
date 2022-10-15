const { gql } = require("apollo-server");

export const mutateUser = gql`
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
      body_weight_rep_lower_bound: Int
      body_weight_rep_upper_bound: Int
      equipment_accessible: [Equipment!]
      workout_type_enrollment: WorkoutType
      ai_managed_workouts_life_cycle: Int
      use_rpe: Boolean
    ): MutateUserResponse
  }
`;
