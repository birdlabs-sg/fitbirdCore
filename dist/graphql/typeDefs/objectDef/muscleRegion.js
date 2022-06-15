"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MuscleRegion = void 0;
const { gql } = require('apollo-server');
exports.MuscleRegion = gql `
    "Represents a specific body part in the human anatomy."
    type MuscleRegion {
        muscle_region_id:          Int        
        muscle_region_name:        String
        muscle_region_description: String
    }
`;
//# sourceMappingURL=muscleRegion.js.map