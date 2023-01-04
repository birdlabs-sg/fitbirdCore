import gql from "graphql-tag";

export const mutateMeasurement = gql`
  "Response if a mutation of a measurement is successful"
  type mutateMeasurementResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    measurement: Measurement
  }

  type Mutation {
    "[PROTECTED] Creates a measurement object for the requestor."
    createMeasurement(
      muscle_region_id: ID!
      measured_at: Date!
      measurement_value: Float!
      length_units: LengthUnit!
    ): mutateMeasurementResponse

    "[PROTECTED] Update a measurement object for the requestor (Must belong to the requestor)."
    updateMeasurement(
      measurement_id: ID!
      measured_at: Date
      muscle_region_id: Int
      measurement_value: Float
      length_units: LengthUnit
    ): mutateMeasurementResponse

    "[PROTECTED] Deletes a measurement object for the requestor (Must belong to the requestor)."
    deleteMeasurement(measurement_id: ID!): mutateMeasurementResponse
  }
`;
