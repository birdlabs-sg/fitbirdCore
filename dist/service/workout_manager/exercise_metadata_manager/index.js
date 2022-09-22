"use strict";
// Retreives the user's exerciseMetadata with respect to the specified exercise.
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateExerciseMetadata = exports.generateOrUpdateExcerciseMetadata = exports.updateExcerciseMetadataWithCompletedWorkout = exports.retrieveExerciseMetadata = void 0;
const utils_1 = require("../utils");
// If does not exists before hand, generate a new one and return that instead.
const retrieveExerciseMetadata = (context, exerciseName) => __awaiter(void 0, void 0, void 0, function* () {
    const prisma = context.dataSources.prisma;
    const excerciseMetadata = yield prisma.excerciseMetadata.findUnique({
        where: {
            user_id_excercise_name: {
                user_id: context.user.user_id,
                excercise_name: exerciseName,
            },
        },
    });
    if (excerciseMetadata) {
        return excerciseMetadata;
    }
    else {
        // generate a new one
        const metadata = yield prisma.excerciseMetadata.create({
            data: {
                user_id: context.user.user_id,
                excercise_name: exerciseName,
            },
        });
        return metadata;
    }
});
exports.retrieveExerciseMetadata = retrieveExerciseMetadata;
// updates a excerciseMetadata with the stats of the completed workout if present
function updateExcerciseMetadataWithCompletedWorkout(context, workout) {
    return __awaiter(this, void 0, void 0, function* () {
        // TODO: Refactor into progressive overload algo
        const prisma = context.dataSources.prisma;
        for (var excercise_group_set of workout.excercise_set_groups) {
            let oldMetadata = yield prisma.excerciseMetadata.findUnique({
                where: {
                    user_id_excercise_name: {
                        user_id: context.user.user_id,
                        excercise_name: excercise_group_set.excercise_name,
                    },
                },
                include: {
                    excercise: true,
                },
            });
            if (oldMetadata == null) {
                oldMetadata = yield prisma.excerciseMetadata.create({
                    data: {
                        user_id: context.user.user_id,
                        excercise_name: excercise_group_set.excercise_name,
                    },
                    include: {
                        excercise: true,
                    },
                });
            }
            // TODO: a way to select best set that takes into account both weight and rep
            let best_set = {
                actual_weight: oldMetadata.best_weight,
                actual_reps: oldMetadata.best_rep,
                weight_unit: oldMetadata.weight_unit,
            };
            for (let excercise_set of excercise_group_set.excercise_sets) {
                if (oldMetadata.excercise.body_weight == true) {
                    if (best_set.actual_reps < excercise_set.actual_reps) {
                        best_set = {
                            actual_weight: excercise_set.actual_weight,
                            actual_reps: excercise_set.actual_reps,
                            weight_unit: excercise_set.weight_unit,
                        };
                    }
                }
                else {
                    if (best_set.actual_weight < excercise_set.actual_weight) {
                        best_set = {
                            actual_weight: excercise_set.actual_weight,
                            actual_reps: excercise_set.actual_reps,
                            weight_unit: excercise_set.weight_unit,
                        };
                    }
                }
            }
            yield prisma.excerciseMetadata.update({
                where: {
                    user_id_excercise_name: {
                        user_id: context.user.user_id,
                        excercise_name: excercise_group_set.excercise_name,
                    },
                },
                data: {
                    best_rep: best_set.actual_reps,
                    best_weight: best_set.actual_weight,
                    weight_unit: best_set.weight_unit,
                    last_excecuted: new Date(),
                },
            });
        }
    });
}
exports.updateExcerciseMetadataWithCompletedWorkout = updateExcerciseMetadataWithCompletedWorkout;
// Generates excerciseMetadata if it's not available for any of the excercises in a workout
function generateOrUpdateExcerciseMetadata(context, excercise_metadatas) {
    return __awaiter(this, void 0, void 0, function* () {
        const prisma = context.dataSources.prisma;
        for (var excercise_metadata of excercise_metadatas) {
            delete excercise_metadata["last_excecuted"];
            const excerciseMetadata = yield prisma.excerciseMetadata.findUnique({
                where: {
                    user_id_excercise_name: {
                        user_id: context.user.user_id,
                        excercise_name: excercise_metadata.excercise_name,
                    },
                },
            });
            if (excerciseMetadata == null) {
                // create one with the excerciseMetadata provided
                yield prisma.excerciseMetadata.create({
                    data: Object.assign({ user_id: context.user.user_id }, excercise_metadata),
                });
            }
            else {
                // update the excerciseMetadata with provided ones
                yield prisma.excerciseMetadata.update({
                    where: {
                        user_id_excercise_name: {
                            user_id: context.user.user_id,
                            excercise_name: excercise_metadata.excercise_name,
                        },
                    },
                    data: Object.assign({ user_id: context.user.user_id }, excercise_metadata),
                });
            }
        }
    });
}
exports.generateOrUpdateExcerciseMetadata = generateOrUpdateExcerciseMetadata;
/**
 * Generates Exercise metadata for the requestor, using @exercise_name
 * Note: function will skip if there is already one existing
 */
function generateExerciseMetadata(context, exercise_name) {
    return __awaiter(this, void 0, void 0, function* () {
        yield (0, utils_1.checkExerciseExists)(context, exercise_name);
        const prisma = context.dataSources.prisma;
        var excerciseMetadata = yield prisma.excerciseMetadata.findUnique({
            where: {
                user_id_excercise_name: {
                    user_id: context.user.user_id,
                    excercise_name: exercise_name,
                },
            },
        });
        if (excerciseMetadata == null) {
            // create one with the excerciseMetadata provided
            excerciseMetadata = yield prisma.excerciseMetadata.create({
                data: {
                    user_id: context.user.user_id,
                    excercise_name: exercise_name,
                },
            });
        }
    });
}
exports.generateExerciseMetadata = generateExerciseMetadata;
//# sourceMappingURL=index.js.map