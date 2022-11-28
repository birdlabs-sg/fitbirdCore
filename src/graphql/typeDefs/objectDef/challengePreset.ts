import gql from "graphql-tag";

export const ChallengePreset = gql`
  "Represents a challenge Preset."
  type ChallengePreset {
    challengePreset_id: Int!
    challenges: [Challenge!]
    preset_workouts: [PresetWorkout!]
    preset_name: String
    duration: Int
    preset_difficulty: PresetDifficulty
    image_url: String
  }
 
`;
