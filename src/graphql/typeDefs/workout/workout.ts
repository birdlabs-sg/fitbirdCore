import gql from "graphql-tag";

export const Workout = gql`
  "Represents a user. Contains meta-data specific to each user."
  type Workout {
    workout_id: ID!
    workout_name: String!
    dayOfWeek: DayOfWeek!
    date_scheduled: Date
    date_closed: Date
    performance_rating: Float
    workout_state: WorkoutState
    excercise_set_groups: [ExcerciseSetGroup!]
    programProgram_id: ID!
  }

  type ExcerciseSetGroup {
    excercise_set_group_id: String
    excercise_name: String!
    excercise: Excercise
    excercise_metadata: ExcerciseMetadata
    excercise_set_group_state: ExcerciseSetGroupState
    excercise_sets: [ExcerciseSet!]!
    failure_reason: FailureReason
  }
`;
