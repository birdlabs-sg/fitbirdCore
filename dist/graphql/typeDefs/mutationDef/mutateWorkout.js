"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.mutateWorkout = void 0;
const { gql } = require("apollo-server");
exports.mutateWorkout = gql `
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
    workouts: [Workout]
  }

  input excerciseSetInput {
    excercise_name: String!
    target_weight: Float!
    weight_unit: WeightUnit!
    target_reps: Int!
    actual_weight: Float
    actual_reps: Int
  }

  type Mutation {
    "[PROTECTED] Creates a workout object for the requestor."
    createWorkout(
      life_span: Int!
      workout_name: String!
      date_scheduled: String
      excercise_sets: [excerciseSetInput]!
    ): mutateWorkoutResponse

    "[PROTECTED] Updates a workout object (Must belong to the requestor). Note: This will replace any existing excercise sets."
    completeWorkout(
      workout_id: ID!
      excercise_sets: [excerciseSetInput]!
    ): mutateWorkoutsResponse

    "[PROTECTED] Updates a workout object (Must belong to the requestor). Note: This will replace any existing excercise sets."
    updateWorkout(
      workout_id: ID!
      date_scheduled: String
      performance_rating: Float
      life_span: Int
      excercise_sets: [excerciseSetInput]
    ): mutateWorkoutResponse

    updateWorkoutOrder(oldIndex: Int, newIndex: Int): mutateWorkoutsResponse

    "[PROTECTED] Deletes a workout object (Must belong to the requestor)."
    deleteWorkout(workout_id: ID!): mutateWorkoutsResponse
  }
`;
//# sourceMappingURL=mutateWorkout.js.map