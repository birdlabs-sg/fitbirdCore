const { gql } = require("apollo-server");

export const Workout = gql`
  "Represents a user. Contains meta-data specific to each user."
  type Workout {
    workout_id: ID!
    workout_name: String
    life_span: Int
    order_index: Int
    date_scheduled: String
    date_completed: String
    performance_rating: Float
    excercise_set_groups: [ExcerciseSetGroup]
    "to remove if works"
    excercise_sets: [ExcerciseSet]
  }
  type ExcerciseSetGroup {
    excercise_name: String!
    excercise: Excercise
    excerciseMetadata: ExcerciseMetadata
    excercise_sets: [ExcerciseSet]!
  }
`;
