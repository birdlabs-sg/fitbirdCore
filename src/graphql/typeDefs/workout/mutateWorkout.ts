import gql from "graphql-tag";

export const mutateWorkout = gql`
  "Response when mutating a workout"
  type mutateWorkoutResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    workout: Workout
  }

  "Response when mutating multiple workouts"
  type mutateWorkoutsResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    workouts: [Workout!]
  }

  input excerciseSetGroupInput {
    excercise_name: String!
    excercise_set_group_state: ExcerciseSetGroupState!
    excercise_metadata: excerciseMetaDataInput!
    excercise_sets: [excerciseSetInput!]!
    failure_reason: FailureReason
  }

  input excerciseMetaDataInput {
    excercise_name: ID!
    rest_time_lower_bound: Int
    rest_time_upper_bound: Int
    preferred: Boolean
    haveRequiredEquipment: Boolean
    excercise_metadata_state: ExcerciseMetadataState
    last_excecuted: Date
    best_weight: Float
    best_rep: Int
    weight_unit: WeightUnit
  }

  input excerciseSetInput {
    target_weight: Float!
    weight_unit: WeightUnit!
    target_reps: Int!
    actual_weight: Float
    actual_reps: Int
    rate_of_perceived_exertion: Int
  }

  type Mutation {
    "[PROTECTED] Creates a workout object for the requestor."
    createWorkout(
      program_id: ID!
      dayOfWeek: DayOfWeek!
      workout_name: String!
      excercise_set_groups: [excerciseSetGroupInput!]!
    ): mutateWorkoutResponse

    "[PROTECTED] Updates a workout object (Must belong to the requestor). Note: This will replace any existing excercise sets."
    completeWorkout(
      workout_id: ID!
      excercise_set_groups: [excerciseSetGroupInput!]!
    ): mutateWorkoutsResponse

    "[PROTECTED] Updates a workout object (Must belong to the requestor). Note: This will replace any existing excercise sets."
    updateWorkout(
      workout_id: ID!
      workout_name: String
      dayOfWeek: DayOfWeek
      date_scheduled: Date
      performance_rating: Float
      workout_state: WorkoutState
      excercise_set_groups: [excerciseSetGroupInput!]
    ): mutateWorkoutResponse

    "[PROTECTED] Deletes a workout object (Must belong to the requestor)."
    deleteWorkout(workout_id: ID!): mutateWorkoutsResponse
  }
`;
