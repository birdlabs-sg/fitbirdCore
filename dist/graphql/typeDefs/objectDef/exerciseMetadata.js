"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ExcerciseMetadata = void 0;
const { gql } = require('apollo-server');
exports.ExcerciseMetadata = gql `
    "Represents a logical component of a workout session."
    type ExcerciseMetadata {
        haveRequiredEquipment: Boolean
        preferred:  Boolean
        rest_time_lower_bound:    Int
        rest_time_upper_bound:    Int
        user_id:      Int    
        excercise_id: Int
    }
`;
//# sourceMappingURL=exerciseMetadata.js.map