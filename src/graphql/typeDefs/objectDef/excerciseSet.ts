const { gql } = require("apollo-server");

export const ExcerciseSet = gql`
  "Represents a logical component of a workout session."
  type ExcerciseSet {
    excercise_set_id: ID!
    target_weight: Float
    weight_unit: WeightUnit
    target_reps: Int
    actual_weight: Float
    actual_reps: Int
    excercise_name: String
  }
`;
