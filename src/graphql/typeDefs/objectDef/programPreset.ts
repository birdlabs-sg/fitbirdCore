import gql from "graphql-tag";

export const programPreset = gql`
  "Represents a challenge Preset."
  type programPreset {
    programPreset_id: Int!
    preset_workouts: [PresetWorkout!]
    preset_name: String
    life_span: Int
    preset_difficulty: PresetDifficulty
    image_url: String
    coach_id: Int
  }
 
`;
