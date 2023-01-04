import gql from "graphql-tag";

export const ExcerciseMetadata = gql`
  "Helps to store extra details of a user for a particular exercise."
  type ExcerciseMetadata {
    excercise_metadata_state: ExcerciseMetadataState!
    haveRequiredEquipment: Boolean
    preferred: Boolean
    last_excecuted: Date
    best_weight: Float
    best_rep: Int
    rest_time_lower_bound: Int
    rest_time_upper_bound: Int
    user_id: ID!
    excercise_name: ID!
    estimated_historical_average_best_rep: Int
    estimated_historical_best_one_rep_max: Float
  }
`;
