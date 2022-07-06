const { gql } = require('apollo-server');

export const mutateWorkout = gql`
    "Response if mutating a excercise was successful"
    type mutateWorkoutResponse implements MutationResponse {
        code: String!
        success: Boolean!
        message: String!
        workout: Workout
    }

    "Optional input parameters for inline creation of excercise blocks within createWorkout mutation"
    input  excerciseSetInput {
        excercise_id: Int!,
        target_weight: Float!,
        weight_unit: WeightUnit!,
        target_reps: Int!,
        actual_weight: Float,
        actual_reps: Int,
    }

    type Mutation {
        "[PROTECTED] Creates a workout object for the requestor."
        createWorkout(
            date_scheduled:String,
            date_completed:String,
            performance_rating:String,
            repetition_count_left: Int!,
            excercise_sets: [excerciseSetInput] 
        )
        : mutateWorkoutResponse

        "[PROTECTED] Updates a workout object (Must belong to the requestor). Note: This will replace any existing excercise sets."
        updateWorkout(
            workout_id: Int!
            repetition_count_left: Int!,
            date_scheduled:String,
            date_completed:String,
            performance_rating:Float,
            order_index: Int
            excercise_sets: [excerciseSetInput] 
        )
        : mutateWorkoutResponse

        "[PROTECTED] Deletes a workout object (Must belong to the requestor)."
        deleteWorkout(
            workout_id: Int!
        )
        : mutateWorkoutResponse
    }
`;