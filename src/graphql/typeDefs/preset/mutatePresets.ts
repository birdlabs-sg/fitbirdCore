import gql from "graphql-tag";

export const mutatePreset = gql`
  "Response if a mutation event is successful"
  type presetResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
  }
  input PresetWorkoutInput {
    preset_excercise_set_groups: [PresetExcerciseSetGroupInput!]!
    rest_day: Boolean
  }
  input PresetExcerciseSetGroupInput {
    excercise_name: String!
    preset_excercise_sets: [PresetExcerciseSetInput!]!
  }
  input PresetExcerciseSetInput {
    target_reps: Int
    target_weight: Float
    weight_unit: WeightUnit
  }

  "[PROTECTED] Mutation to create a programPreset"
  type Mutation {
    createProgramPreset(
      preset_workouts: [PresetWorkoutInput!]!
      preset_name: String!
      life_span: Int!
      preset_difficulty: PresetDifficulty!
      image_url: String
    ): presetResponse

    "[PROTECTED] Mutation to delete a programPreset"
    deleteProgramPreset(programPreset_id: ID!): presetResponse
  }
`;
