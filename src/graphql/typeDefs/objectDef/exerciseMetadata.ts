const { gql } = require("apollo-server");

export const ExcerciseMetadata = gql`
  "Represents a logical component of a workout session."
  type ExcerciseMetadata {
    excercise_metadata_state: ExcerciseMetadataState!
    excercise_name: String!
    haveRequiredEquipment: Boolean
    preferred: Boolean
    rest_time_lower_bound: Int!
    rest_time_upper_bound: Int!
  }
`;