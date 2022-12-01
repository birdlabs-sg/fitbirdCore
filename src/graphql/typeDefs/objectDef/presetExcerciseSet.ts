import gql from "graphql-tag";

export const PresetExcerciseSet = gql`
"Represents an excercise set group Preset."
  type PresetExcerciseSet {
    preset_excercise_set_id:Int!
    target_reps:Int
    target_weight:Float
    weight_unit:WeightUnit
  }
  
  `