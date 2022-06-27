"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ExcerciseSet = void 0;
const { gql } = require('apollo-server');
exports.ExcerciseSet = gql `
    "Represents a logical component of a workout session."
    type ExcerciseSet {
        excercise_set_id: Int,
        workout_id:   Int
        excercise_id: Int
        target_weight:       Float
        target_weight_unit:  WeightUnit
        target_reps: Int
        actual_weight:         Float
        actual_weight_unit:    WeightUnit
        actual_reps: Int
    }
`;
//# sourceMappingURL=ExcerciseSet.js.map