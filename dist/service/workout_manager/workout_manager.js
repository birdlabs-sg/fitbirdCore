"use strict";
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
exports.reorderActiveWorkouts = exports.checkExistsAndOwnership = exports.getActiveWorkoutCount = exports.updateExcerciseMetadataWithCompletedWorkout = exports.generateOrUpdateExcerciseMetadata = void 0;
const apollo_server_1 = require("apollo-server");
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
function getActiveWorkoutCount(context) {
    return __awaiter(this, void 0, void 0, function* () {
        const prisma = context.dataSources.prisma;
        const workouts = yield prisma.workout.findMany({
            where: {
                date_completed: null,
                user_id: context.user.user_id,
            },
            orderBy: {
                order_index: "asc",
            },
        });
        return workouts.length;
    });
}
exports.getActiveWorkoutCount = getActiveWorkoutCount;
function checkExistsAndOwnership(context, workout_id) {
    return __awaiter(this, void 0, void 0, function* () {
        const prisma = context.dataSources.prisma;
        const targetWorkout = yield prisma.workout.findUnique({
            where: {
                workout_id: parseInt(workout_id),
            },
        });
        if (targetWorkout == null) {
            throw new Error("The workout does not exist.");
        }
        if (targetWorkout.user_id != context.user.user_id) {
            throw new apollo_server_1.AuthenticationError("You are not authorized to remove this object");
        }
    });
}
exports.checkExistsAndOwnership = checkExistsAndOwnership;
function reorderActiveWorkouts(context, oldIndex, newIndex) {
    return __awaiter(this, void 0, void 0, function* () {
        const prisma = context.dataSources.prisma;
        const active_workouts = yield prisma.workout.findMany({
            where: {
                date_completed: null,
                user_id: context.user.user_id,
            },
            orderBy: {
                order_index: "asc",
            },
        });
        if (oldIndex != undefined && newIndex != undefined) {
            if (oldIndex < newIndex) {
                newIndex -= 1;
            }
            const workout = active_workouts.splice(oldIndex, 1)[0];
            active_workouts.splice(newIndex, 0, workout);
        }
        for (var i = 0; i < active_workouts.length; i++) {
            const { workout_id } = active_workouts[i];
            yield prisma.workout.update({
                where: {
                    workout_id: workout_id,
                },
                data: {
                    order_index: i,
                },
            });
        }
    });
}
exports.reorderActiveWorkouts = reorderActiveWorkouts;
//# sourceMappingURL=workout_manager.js.map