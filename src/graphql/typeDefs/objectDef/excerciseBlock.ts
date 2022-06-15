const { gql } = require('apollo-server');

export const ExcerciseBlock = gql`
    "Represents a logical component of a workout session."
    type ExcerciseBlock {
        workout_id:   Int
        excercise_id: Int
        weight:       Float
        weight_unit:  WeightUnit
        reps_per_set: Int
        sets:         Int
        failed_count: Int
        rest_time:    Int
    }
`;