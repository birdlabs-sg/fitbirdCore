import gql from "graphql-tag";

export const mutateMuscleRegion = gql`
  "Response if mutating a muscle region was successful"
  type mutateMuscleRegionResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    muscle_region: MuscleRegion
  }

  type Mutation {
    "[PROTECTED] Creates a muscle region object."
    createMuscleRegion(
      muscle_region_name: String!
      muscle_region_description: String!
      muscle_region_type: MuscleRegionType!
    ): mutateMuscleRegionResponse

    "[PROTECTED] Updates a muscle region object."
    updateMuscleRegion(
      muscle_region_id: ID!
      muscle_region_name: String
      muscle_region_description: String
    ): mutateMuscleRegionResponse

    "[PROTECTED] Deletes a muscle region object."
    deleteMuscleRegion(muscle_region_id: ID!): mutateMuscleRegionResponse
  }
`;