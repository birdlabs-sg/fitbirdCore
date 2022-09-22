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
var __rest = (this && this.__rest) || function (s, e) {
    var t = {};
    for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p) && e.indexOf(p) < 0)
        t[p] = s[p];
    if (s != null && typeof Object.getOwnPropertySymbols === "function")
        for (var i = 0, p = Object.getOwnPropertySymbols(s); i < p.length; i++) {
            if (e.indexOf(p[i]) < 0 && Object.prototype.propertyIsEnumerable.call(s, p[i]))
                t[p[i]] = s[p[i]];
        }
    return t;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateNextWorkout = exports.reorderActiveWorkouts = exports.checkExistsAndOwnership = exports.getActiveWorkoutCount = exports.updateExcerciseMetadataWithCompletedWorkout = exports.generateOrUpdateExcerciseMetadata = exports.generateExerciseMetadata = exports.getActiveWorkouts = exports.excerciseSetGroupsTransformer = exports.formatExcerciseSetGroups = exports.extractMetadatas = void 0;
const apollo_server_1 = require("apollo-server");
const graphql_1 = require("../../types/graphql");
const progressive_overloader_1 = require("./progressive_overloader");
const _ = require("lodash");
function extractMetadatas(excerciseSetGroupsInput) {
    const excercise_metadatas = [];
    const excerciseGroups = excerciseSetGroupsInput.map((excerciseSetGroupInput) => {
        const { excercise_metadata } = excerciseSetGroupInput, excerciseSetGroup = __rest(excerciseSetGroupInput, ["excercise_metadata"]);
        if (excercise_metadata) {
            excercise_metadatas.push(excercise_metadata);
        }
        return excerciseSetGroup;
    });
    return [excerciseGroups, excercise_metadatas];
}
exports.extractMetadatas = extractMetadatas;
function formatExcerciseSetGroups(excerciseSetGroups) {
    const formattedData = excerciseSetGroups.map(function (excerciseSetGroup) {
        var { excercise_sets, excercise_name, excercise_set_group_state } = excerciseSetGroup, rest = __rest(excerciseSetGroup, ["excercise_sets", "excercise_name", "excercise_set_group_state"]);
        return Object.assign(Object.assign({}, rest), { excercise: {
                connect: {
                    excercise_name: excercise_name,
                },
            }, excercise_set_group_state: excercise_set_group_state, excercise_sets: {
                create: excercise_sets,
            } });
    });
    return formattedData;
}
exports.formatExcerciseSetGroups = formatExcerciseSetGroups;
// Transform the incoming excerciseSetGroups into excercise_sets
function excerciseSetGroupsTransformer(excercise_set_groups) {
    var current_excercise_group_sets = [];
    var next_excercise_group_sets = [];
    for (var excercise_set_group of excercise_set_groups) {
        switch (excercise_set_group.excercise_set_group_state) {
            case graphql_1.ExcerciseSetGroupState.DeletedPermanantly:
                // 1. Will not be in subsequent workouts
                // 2. Will not be in the crrent workout
                break;
            case graphql_1.ExcerciseSetGroupState.DeletedTemporarily:
                // 1. Will conitnue to be in subsequent workouts
                // 2. Will not be in the current workout
                next_excercise_group_sets.push(excercise_set_group);
                break;
            case graphql_1.ExcerciseSetGroupState.ReplacementPermanantly:
                // 1. Will be in subsequent workouts
                // 2. Will be in the current workout
                next_excercise_group_sets.push(excercise_set_group);
                current_excercise_group_sets.push(excercise_set_group);
                break;
            case graphql_1.ExcerciseSetGroupState.ReplacementTemporarily:
                // 1. Will not be in subsequent workouts
                // 2. Will be in the current workout
                current_excercise_group_sets.push(excercise_set_group);
                break;
            case graphql_1.ExcerciseSetGroupState.NormalOperation:
                // 1. Will be in subsequent workouts
                // 2. Will be in the current workout
                next_excercise_group_sets.push(excercise_set_group);
                current_excercise_group_sets.push(excercise_set_group);
                break;
        }
    }
    return [current_excercise_group_sets, next_excercise_group_sets];
}
exports.excerciseSetGroupsTransformer = excerciseSetGroupsTransformer;
// Gets all active workouts
function getActiveWorkouts(context) {
    return __awaiter(this, void 0, void 0, function* () {
        const prisma = context.dataSources.prisma;
        return yield prisma.workout.findMany({
            where: {
                date_completed: null,
                user_id: context.user.user_id,
            },
            orderBy: {
                order_index: "asc",
            },
        });
    });
}
exports.getActiveWorkouts = getActiveWorkouts;
const generateExerciseMetadata = (context, exercise_name) => __awaiter(void 0, void 0, void 0, function* () {
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
exports.generateExerciseMetadata = generateExerciseMetadata;
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
function generateNextWorkout(context, previousWorkout, next_workout_excercise_set_groups) {
    return __awaiter(this, void 0, void 0, function* () {
        const prisma = context.dataSources.prisma;
        const { life_span, workout_name, excercise_set_groups } = previousWorkout;
        var previousExerciseSetGroups = excercise_set_groups;
        // Don't need progressive overload because it was NOT completed in previous workout (It was temporarily replaced or removed)
        const excercise_set_groups_without_progressive_overload = _.differenceWith(next_workout_excercise_set_groups, previousExerciseSetGroups, (x, y) => x.excercise_name === y.excercise_name);
        // Need progressive overload because it was completed in the previous workout
        const excercise_set_groups_to_progressive_overload = _.differenceWith(next_workout_excercise_set_groups, excercise_set_groups_without_progressive_overload, (x, y) => x.excercise_name === y.excercise_name);
        const progressively_overloaded_excercise_set_groups = yield (0, progressive_overloader_1.progressivelyOverload)(excercise_set_groups_to_progressive_overload, context);
        // Combine the excerciseSetGroups together and set them to back to normal operation
        const finalExcerciseSetGroups = excercise_set_groups_without_progressive_overload
            .concat(progressively_overloaded_excercise_set_groups)
            .map((e) => (Object.assign(Object.assign({}, e), { excercise_set_group_state: graphql_1.ExcerciseSetGroupState.NormalOperation })));
        // Create the workout and slot behind the rest of the queue.
        yield prisma.workout.create({
            data: {
                user_id: context.user.user_id,
                workout_name: workout_name,
                life_span: life_span - 1,
                order_index: yield getActiveWorkoutCount(context),
                excercise_set_groups: {
                    create: formatExcerciseSetGroups(finalExcerciseSetGroups),
                },
            },
        });
    });
}
exports.generateNextWorkout = generateNextWorkout;
//# sourceMappingURL=workout_manager.js.map