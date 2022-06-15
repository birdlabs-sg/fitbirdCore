"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.mutateExcerciseBlock = void 0;
const { gql } = require('apollo-server');
exports.mutateExcerciseBlock = gql `
    "Response if mutating a excercise block was successful"
    type mutateExcerciseBlockResponse implements MutationResponse {
        code: String!
        success: Boolean!
        message: String!
        excercise_block: ExcerciseBlock
    }

    type Mutation {
        "[PROTECTED] Creates a excercise block object."
        createExcerciseBlock(
            workout_id: Int!,
            excercise_id: Int!,
            weight: Float!,
            weight_unit: WeightUnit!,
            reps_per_set: Int!,
            sets: Int!,
            failed_count: Int,
            rest_time: Int,
        )
        : mutateExcerciseBlockResponse

        "[PROTECTED] Updates a excercise block object."
        updateExcerciseBlock(
            workout_id: Int!,
            excercise_id: Int!,
            weight: Float!,
            weight_unit: WeightUnit!,
            reps_per_set: Int!,
            sets: Int!,
            failed_count: Int,
            rest_time: Int,
        )
        : mutateExcerciseBlockResponse

        "[PROTECTED] Deletes a excercise block object."
        deleteExcerciseBlock(
            workout_id: Int!,
            excercise_id: Int!,
            weight: Float!,
            weight_unit: WeightUnit!,
            reps_per_set: Int!,
            sets: Int!,
        )
        : mutateExcerciseBlockResponse
    }
`;
//# sourceMappingURL=mutateExcerciseBlock.js.map