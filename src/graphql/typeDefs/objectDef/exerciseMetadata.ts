const { gql } = require("apollo-server");

export const ExcerciseMetadata = gql`
  "Represents a logical component of a workout session."
  type ExcerciseMetadata {
    excercise_metadata_state: ExcerciseMetadataState!
    haveRequiredEquipment: Boolean
    preferred: Boolean
    last_excecuted: String
    excercise_name: String!
    best_weight: Float!
    weight_unit: WeightUnit!
    best_rep: Int!
    rest_time_lower_bound: Int!
    rest_time_upper_bound: Int!
  }
`;
