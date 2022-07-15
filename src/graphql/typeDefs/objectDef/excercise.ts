const { gql } = require("apollo-server");

export const Excercise = gql`
  "Represents a specific excercise."
  type Excercise {
    excercise_id: ID!
    excercise_name: String
    excercise_preparation: String
    excercise_instructions: String
    excercise_tips: String
    excercise_utility: [String]
    excercise_mechanics: [String]
    excercise_force: [String]
    target_regions: [MuscleRegion]
    stabilizer_muscles: [MuscleRegion]
    synergist_muscles: [MuscleRegion]
    dynamic_stabilizer_muscles: [MuscleRegion]
    excerciseMetadata: ExcerciseMetadata
  }
`;
