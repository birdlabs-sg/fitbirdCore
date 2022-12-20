import gql from "graphql-tag";
export const PresetWorkout = gql`
type PresetWorkout{
    preset_workout_id: Int!
    preset_excercise_set_groups:[PresetExcerciseSetGroup!]!
    rest_day:Boolean
    program_preset_id: Int
  }
  type PresetExcerciseSetGroup {
    preset_excercise_set_group_id: Int!
    preset_excercise_sets:[PresetExcerciseSet!]!
    preset_workout_id: Int
    excercise_name:String!
  }
  `