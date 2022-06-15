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
    input  createExcerciseBlockInput {
        excercise_id: Int!,
        weight: Float!,
        weight_unit: WeightUnit!,
        reps_per_set: Int!,
        sets: Int!,
    }

    type Mutation {
        "[PROTECTED] Creates a workout object for the requestor."
        createWorkout(
            date_scheduled:String!,
            date_completed:String,
            performance_rating:String,
            excercise_blocks: [createExcerciseBlockInput] 
        )
        : mutateWorkoutResponse

        "[PROTECTED] Updates a workout object (Must belong to the requestor)."
        updateWorkout(
            workout_id: Int!
            date_scheduled:String,
            date_completed:String,
            performance_rating:Float,
        )
        : mutateWorkoutResponse

        "[PROTECTED] Deletes a workout object (Must belong to the requestor)."
        deleteWorkout(
            workout_id: Int!
        )
        : mutateWorkoutResponse
    }
`;