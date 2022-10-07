const { gql } = require("apollo-server");
export const mutateProgram = gql`
type mutateProgramResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    program: Program
  }
  input excerciseSetGroupInput {
    excercise_name: String!
    excercise_set_group_state: ExcerciseSetGroupState!
    excercise_metadata: excerciseMetaDataInput!
    excercise_sets: [excerciseSetInput!]!
    failure_reason: FailureReason
  }

  input excerciseMetaDataInput {
    excercise_name: ID!
    rest_time_lower_bound: Int
    rest_time_upper_bound: Int
    preferred: Boolean
    haveRequiredEquipment: Boolean
    excercise_metadata_state: ExcerciseMetadataState
    last_excecuted: Date
    best_weight: Float
    best_rep: Int
    weight_unit: WeightUnit
  }

  input excerciseSetInput {
    target_weight: Float!
    weight_unit: WeightUnit!
    target_reps: Int!
    actual_weight: Float
    actual_reps: Int
    rate_of_perceived_exertion: Int
  }
  input workoutInput {
    user_id: ID!
    workout_type:WorkoutType!
    workout_name: String
    date_scheduled: Date
    order_index:Int
    life_span: Int
    workout_state: WorkoutState
    excercise_set_groups: [excerciseSetGroupInput!]
  }

type Mutation {
"[PROTECTED] Creates a program object (ONLY COACH)."
    createProgram(
        user_id: ID!
        workouts: [workoutInput!]
    ):mutateProgramResponse
  }
`;
