import gql from "graphql-tag";

export const mutatePreset = gql`
  "Response if a mutation event is successful"
  type ChallengePresetResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    user: ChallengePreset
  }
  input PresetWorkoutInput{
    preset_excercise_set_groups:[PresetExcerciseSetGroupInput!]!
    rest_day:Boolean
  }
  input PresetExcerciseSetGroupInput {
    excercise_name:String!
    preset_excercise_sets:[PresetExcerciseSetInput!]!
  }
  input PresetExcerciseSetInput{
    target_reps:Int
    target_weight:Float
  }

  "[PROTECTED] Mutation to create a challengePreset"
  type Mutation {
    createChallengePreset(
        preset_Workouts:[PresetWorkoutInput!]!
        preset_name:String!
        duration:Int!
        preset_difficulty:PresetDifficulty!
        image_url:String
    ): ChallengePresetResponse
  }
`;
