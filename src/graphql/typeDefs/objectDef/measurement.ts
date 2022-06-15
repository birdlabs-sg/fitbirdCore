const { gql } = require('apollo-server');

export const Measurement = gql`
    "Represents a measurement of a body part taken at a certain date."
    type Measurement {
        measurement_id: ID      
        measured_at:     String
        muscle_region:   MuscleRegion
        measurement_value:          Float
        length_units:   LengthUnit
        user_id:           Int
}
`;