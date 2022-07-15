const { gql } = require("apollo-server");

export const mutateWorkout = gql`
  "Response if mutating a excercise was successful"
  type mutateWorkoutResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    workout: Workout
  }

  "Response if mutating the workout order succeeds"
  type mutateWorkoutOrderResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    workout_id: ID
    workouts: [Workout]
  }

  "Optional input parameters for inline creation of excercise blocks within createWorkout mutation"
  input createWorkoutExcerciseSetInput {
    excercise_set_id: ID!
    excercise_id: ID!
    target_weight: Float!
    weight_unit: WeightUnit!
    target_reps: Int!
    to_delete: Boolean!
  }

  input completeWorkoutExcerciseSetInput {
    excercise_set_id: ID!
    excercise_id: ID!
    target_weight: Float!
    weight_unit: WeightUnit!
    target_reps: Int!
    actual_weight: Float!
    actual_reps: Int!
    to_delete: Boolean!
  }

  input updateWorkoutExcerciseSetInput {
    excercise_set_id: ID!
    excercise_id: ID!
    target_weight: Float!
    weight_unit: WeightUnit!
    target_reps: Int!
    actual_weight: Float
    actual_reps: Int
    to_delete: Boolean!
  }

  input createWorkoutGroupInput {
    life_span: Int!
    workout_group_name: String!
  }

  type Mutation {
    "[PROTECTED] Creates a workout object for the requestor."
    createWorkout(
      workout_group: createWorkoutGroupInput
      date_scheduled: String
      excercise_sets: [createWorkoutExcerciseSetInput]
    ): mutateWorkoutResponse

    "[PROTECTED] Updates a workout object (Must belong to the requestor). Note: This will replace any existing excercise sets."
    completeWorkout(
      workout_id: ID!
      excercise_sets: [completeWorkoutExcerciseSetInput]!
    ): mutateWorkoutOrderResponse

    "[PROTECTED] Updates a workout object (Must belong to the requestor). Note: This will replace any existing excercise sets."
    updateWorkout(
      workout_id: ID!
      date_scheduled: String
      date_completed: String
      performance_rating: Float
      order_index: Int
      excercise_sets: [updateWorkoutExcerciseSetInput]
    ): mutateWorkoutResponse

    updateWorkoutOrder(oldIndex: Int, newIndex: Int): mutateWorkoutOrderResponse

    "[PROTECTED] Deletes a workout object (Must belong to the requestor)."
    deleteWorkout(workout_id: ID!): mutateWorkoutOrderResponse
  }
`;
