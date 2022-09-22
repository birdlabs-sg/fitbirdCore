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
exports.checkExerciseExists = exports.checkExistsAndOwnership = exports.getActiveWorkoutCount = exports.getActiveWorkouts = exports.exerciseSetGroupStateSeperator = exports.extractMetadatas = exports.formatExcerciseSetGroups = exports.formatAndGenerateExcerciseSets = void 0;
const graphql_1 = require("../../types/graphql");
const apollo_server_1 = require("apollo-server");
const exercise_metadata_manager_1 = require("./exercise_metadata_manager/exercise_metadata_manager");
const _ = require("lodash");
/**
 * Generates exercise sets and formats them to be used in Prisma
 * Note: If there is previous data from past workouts, it will duplicte those sets,
 * otherwise 5 black exercise sets will be created (Calibration workflow)
 */
function formatAndGenerateExcerciseSets(excercise_name, context) {
    return __awaiter(this, void 0, void 0, function* () {
        yield checkExerciseExists(context, excercise_name);
        const prisma = context.dataSources.prisma;
        const user = context.user;
        var previous_excercise_sets = [];
        var excercise_sets_input = [];
        // Checks if there is previous data, will use that instead
        var previousExcerciseSetGroup = yield prisma.excerciseSetGroup.findFirst({
            where: {
                excercise_name: excercise_name,
                workout: {
                    user_id: user.user_id,
                    date_completed: { not: null },
                },
            },
            include: {
                excercise_sets: true,
            },
        });
        (0, exercise_metadata_manager_1.generateExerciseMetadata)(context, excercise_name);
        if (previousExcerciseSetGroup != null) {
            // previous_excercise_sets = previousExcerciseSetGroup.excercise_sets;
            previous_excercise_sets.forEach((prev_set) => {
                var excercise_set_input = _.omit(prev_set, "excercise_set_group_id", "excercise_set_id");
                excercise_set_input["actual_reps"] = null;
                excercise_set_input["actual_weight"] = null;
                excercise_sets_input.push(excercise_set_input);
            });
        }
        else {
            // No previous data
            excercise_sets_input = new Array(5).fill({
                target_weight: 0,
                weight_unit: "KG",
                target_reps: 0,
                actual_weight: null,
                actual_reps: null,
            });
        }
        return {
            excercise: { connect: { excercise_name: excercise_name } },
            excercise_set_group_state: graphql_1.ExcerciseSetGroupState.NormalOperation,
            excercise_sets: { create: excercise_sets_input },
        };
    });
}
exports.formatAndGenerateExcerciseSets = formatAndGenerateExcerciseSets;
/**
 * Helps to format Exercise Set Groups into the form required by Prisma for update/creation
 */
function formatExcerciseSetGroups(excerciseSetGroups) {
    const formattedData = excerciseSetGroups.map(function (excerciseSetGroup) {
        var { excercise_sets, excercise_name, excercise_set_group_state, failure_reason, } = excerciseSetGroup;
        return {
            failure_reason,
            excercise: {
                connect: {
                    excercise_name: excercise_name,
                },
            },
            excercise_set_group_state: excercise_set_group_state,
            excercise_sets: {
                create: excercise_sets,
            },
        };
    });
    return formattedData;
}
exports.formatExcerciseSetGroups = formatExcerciseSetGroups;
/**
 * Helps to split the incoming object of type:  @ExcerciseSetGroupInput (This contains exerciseMetadata which is not found in the database)
 * The result is an array of 2 arrays.
 *
 * First is of type @PrismaExerciseSetGroupCreateArgs
 * Second is of type @ExcerciseMetaDataInput
 */
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
/**
 * Helps to seggregate a list of ExerciseSetGroups into those that have been "Deleted"
 * and those that were "completed/skipped".
 *
 * Note:
 * 1. This will be used to generate the next workout
 * 2. This is only called by generateNextWorkout() function
 */
function exerciseSetGroupStateSeperator(excercise_set_groups) {
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
exports.exerciseSetGroupStateSeperator = exerciseSetGroupStateSeperator;
/**
 * Helps to get all active workouts (AKA the current rotation)
 *
 */
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
/**
 * Helps to get all active workouts "COUNT" (AKA the current rotation)
 *
 * Note:
 * If you want the workouts itself, call getActiveWorkouts()
 */
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
/**
 * 1. Enforces that the requestor is the owner of the workout identified by @workout_id
 * 2. Also ensures that the workout of interests exists in the first place
 */
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
/**
 * Enforces that an exercise exists identified by @workout_id
 *
 */
function checkExerciseExists(context, exercise_name) {
    return __awaiter(this, void 0, void 0, function* () {
        const prisma = context.dataSources.prisma;
        const exercise = yield prisma.excercise.findUnique({
            where: {
                excercise_name: exercise_name,
            },
        });
        if (exercise == null) {
            throw new Error("No exercise found");
        }
    });
}
exports.checkExerciseExists = checkExerciseExists;
//# sourceMappingURL=utils.js.map