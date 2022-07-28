const { gql } = require("apollo-server");

export const mutateExcerciseMetadata = gql`
  "Response if mutating a excercise was successful"
  type mutateExcerciseMetaDataResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    excerciseMetadata: ExcerciseMetadata
  }

  type Mutation {
    "[PROTECTED] Updates a excerciseMetadata object."
    updateExcerciseMetadata(
      excercise_name: ID!
      rest_time_lower_bound: Int
      rest_time_upper_bound: Int
      preferred: Boolean
      haveRequiredEquipment: Boolean
    ): mutateExcerciseMetaDataResponse

    createExcerciseMetadata(
      excercise_name: ID!
      rest_time_lower_bound: Int!
      rest_time_upper_bound: Int!
      preferred: Boolean
      haveRequiredEquipment: Boolean
    ): mutateExcerciseMetaDataResponse
  }
`;
