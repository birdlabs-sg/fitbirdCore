import gql from "graphql-tag";

export const mutateExcerciseMetadata = gql`
  "Response if mutating a excercise was successful"
  type mutateExcerciseMetaDataResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    excercise_metadata: ExcerciseMetadata
  }

  type Mutation {
    "[PROTECTED] Updates a excerciseMetadata object."
    updateExcerciseMetadata(
      excercise_name: ID!
      excercise_metadata_state: ExcerciseMetadataState!
      haveRequiredEquipment: Boolean
      preferred: Boolean
      last_excecuted: Date
      best_weight: Float
      best_rep: Int
      rest_time_lower_bound: Int
      rest_time_upper_bound: Int
      estimated_historical_average_best_rep: Int
      estimated_historical_best_one_rep_max: Float
    ): mutateExcerciseMetaDataResponse

    createExcerciseMetadata(
      user_id: ID!
      excercise_name: ID!
      excercise_metadata_state: ExcerciseMetadataState
      haveRequiredEquipment: Boolean
      preferred: Boolean
      last_excecuted: Date
      best_weight: Float
      best_rep: Int
      rest_time_lower_bound: Int
      rest_time_upper_bound: Int
      estimated_historical_average_best_rep: Int
      estimated_historical_best_one_rep_max: Float
    ): mutateExcerciseMetaDataResponse
  }
`;
