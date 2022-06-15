"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Measurement = void 0;
const { gql } = require('apollo-server');
exports.Measurement = gql `
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
//# sourceMappingURL=measurement.js.map