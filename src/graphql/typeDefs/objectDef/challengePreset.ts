import gql from "graphql-tag";

export const ChallengePreset = gql`
  "Represents a challenge Preset."
  type ChallengePreset {
    challengePreset_id: ID!
    challenges: [Challenge]
    preset_Workouts: [PresetWorkout!]!
    preset_name: String
    duration: Int
    preset_difficulty: PresetDifficulty
    image_url: String
  }
  type PresetWorkout{
    preset_workout_id: ID!
    challengePreset_id:ID!
    preset_excercise_set_groups:[PresetExcerciseSetGroup!]!
    rest_day:Boolean
  }
  type PresetExcerciseSetGroup {
    preset_excercise_set_group_id: ID!
    preset_workout_id:ID!
    excercise_name:String!
    preset_excercise_sets:[PresetExcerciseSet!]!
  }
  type PresetExcerciseSet {
    preset_excercise_set_id:ID!
    preset_excercise_set_group_id:ID!
    target_reps:Int
    target_weight:Float
  }
`;
