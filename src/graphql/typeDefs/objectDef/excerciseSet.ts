const { gql } = require('apollo-server');

export const ExcerciseSet = gql`
    "Represents a logical component of a workout session."
    type ExcerciseSet {
        excercise_set_id: Int,
        workout_id:   Int
        excercise_id: Int
        target_weight:       Float
        target_weight_unit:  WeightUnit
        target_reps: Int
        actual_weight:         Float
        actual_weight_unit:    WeightUnit
        actual_reps: Int
        excercise: Excercise
    }
`;