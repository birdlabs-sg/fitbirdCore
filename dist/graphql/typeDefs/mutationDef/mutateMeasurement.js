"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.mutateMeasurement = void 0;
const { gql } = require('apollo-server');
exports.mutateMeasurement = gql `
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
            muscle_region_id: Int!,
            measured_at:    String!,
            measurement_value: Float!,
            length_units: LengthUnit!,
        )
        : mutateMeasurementResponse
        
        "[PROTECTED] Update a measurement object for the requestor (Must belong to the requestor)."
        updateMeasurement(
            measurement_id: Int!,
            measured_at: String,
            muscle_region_id: Int,
            measurement_value: Float,
            length_units: LengthUnit,
        )
        : mutateMeasurementResponse

        "[PROTECTED] Deletes a measurement object for the requestor (Must belong to the requestor)."
        deleteMeasurement(
            measurement_id: Int!,
        )
        : mutateMeasurementResponse
    }
`;
//# sourceMappingURL=mutateMeasurement.js.map