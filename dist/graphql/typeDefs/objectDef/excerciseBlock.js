"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ExcerciseBlock = void 0;
const { gql } = require('apollo-server');
exports.ExcerciseBlock = gql `
    "Represents a logical component of a workout session."
    type ExcerciseBlock {
        workout_id:   Int
        excercise_id: Int
        weight:       Float
        weight_unit:  WeightUnit
        reps_per_set: Int
        sets:         Int
        failed_count: Int
        rest_time:    Int
    }
`;
//# sourceMappingURL=excerciseBlock.js.map