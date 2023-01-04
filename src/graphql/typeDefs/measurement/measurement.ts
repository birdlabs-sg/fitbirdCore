import gql from "graphql-tag";

export const Measurement = gql`
  "Represents a measurement of a body part taken at a certain date."
  type Measurement {
    measurement_id: ID!
    measured_at: Date
    muscle_region: MuscleRegion
    measurement_value: Float
    length_units: LengthUnit
    user_id: Int
  }
`;
