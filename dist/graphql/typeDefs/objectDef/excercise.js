"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Excercise = void 0;
const { gql } = require('apollo-server');
exports.Excercise = gql `
    "Represents a specific excercise."
    type Excercise {
        excercise_id:          ID           
        excercise_name:        String
        excercise_preparation: String
        excercise_instructions: String
        target_regions:        [MuscleRegion]
        stabilizer_muscles:        [MuscleRegion]
        synergist_muscles:        [MuscleRegion]
        dynamic_stabilizer_muscles:        [MuscleRegion]
    }
`;
//# sourceMappingURL=excercise.js.map