const { gql } = require("apollo-server");

export const Workout = gql`
  "Represents a user. Contains meta-data specific to each user."
  type Workout {
    user_id: ID
    workout_id: ID!
    workout_name: String
    life_span: Int
    order_index: Int
    date_scheduled: Date
    date_completed: Date
    performance_rating: Float
    excercise_set_groups: [ExcerciseSetGroup!]
    workout_state: WorkoutState
    workout_type: WorkoutType
  }

  type ExcerciseSetGroup {
    excercise_set_group_id: String
    excercise_name: String!
    excercise: Excercise
    excercise_metadata: ExcerciseMetadata
    excercise_set_group_state: ExcerciseSetGroupState
    excercise_sets: [ExcerciseSet!]!
    failure_reason: FailureReason
    rate_of_perceived_exertion: Float
  }
`;
