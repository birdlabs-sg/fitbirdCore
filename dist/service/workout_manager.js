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
exports.generateNextWorkout = exports.formatExcerciseSets = exports.reorderActiveWorkouts = exports.enforceWorkoutExistsAndOwnership = void 0;
const apollo_server_1 = require("apollo-server");
const enforceWorkoutExistsAndOwnership = (context, targetWorkout) => {
    if (targetWorkout == null) {
        throw new Error("The workout does not exist.");
    }
    if (targetWorkout.workoutGroup.user_id != context.user.user_id) {
        throw new apollo_server_1.AuthenticationError("You are not authorized to remove this object");
    }
};
exports.enforceWorkoutExistsAndOwnership = enforceWorkoutExistsAndOwnership;
const reorderActiveWorkouts = (context, oldIndex, newIndex) => __awaiter(void 0, void 0, void 0, function* () {
    const prisma = context.dataSources.prisma;
    const active_workouts = yield prisma.workout.findMany({
        where: {
            date_completed: null,
            workoutGroup: {
                user_id: context.user.user_id,
            },
        },
        orderBy: {
            order_index: "asc",
        },
    });
    if (oldIndex != null && newIndex != null) {
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
                excercise_sets: undefined,
            },
        });
    }
});
exports.reorderActiveWorkouts = reorderActiveWorkouts;
const formatExcerciseSets = (unformattedExcerciseSets) => {
    const cleaned_excercise_sets = [];
    for (let i = 0; i < unformattedExcerciseSets.length; i++) {
        if (unformattedExcerciseSets[i].to_delete == false) {
            const _a = unformattedExcerciseSets[i], { to_delete, excercise_set_id, excercise_id } = _a, cleaned_excercise_set = __rest(_a, ["to_delete", "excercise_set_id", "excercise_id"]);
            cleaned_excercise_set["excercise_id"] = parseInt(excercise_id);
            cleaned_excercise_sets.push(cleaned_excercise_set);
        }
    }
    return cleaned_excercise_sets;
};
exports.formatExcerciseSets = formatExcerciseSets;
const generateNextWorkout = (context, previousWorkout) => __awaiter(void 0, void 0, void 0, function* () {
    const prisma = context.dataSources.prisma;
    const { excercise_sets, workout_group_id } = previousWorkout, otherArgs = __rest(previousWorkout, ["excercise_sets", "workout_group_id"]);
    const rateExcerciseSet = (excercise_set) => {
        // TODO: Can return a multiplier value based off how far he is from the bench mark next.
        var benchMark;
        if (excercise_set.target_weight == excercise_set.actual_weight) {
            // 1. At same weight
            benchMark = excercise_set.target_reps;
        }
        else if (excercise_set.target_weight > excercise_set.actual_weight) {
            // 2. At a lower weight, Bench mark = target reps * 1.15
            benchMark = excercise_set.target_reps * 1.15;
        }
        else {
            // 3. At a higher weight, Bench mark = target reps * 0.85
            benchMark = excercise_set.target_reps * 0.85;
        }
        if (excercise_set.actual_reps < benchMark) {
            return "FAILED";
        }
        else if (excercise_set.actual_reps == benchMark) {
            return "MAINTAINED";
        }
        else {
            return "EXCEED";
        }
    };
    const lowerBound = 4;
    const upperBound = 8;
    const new_excercise_sets = [];
    // TODO: give a more accurate benchmark
    // We consider the set to fail when the actual reps is lower than the benchmark.
    // Bench marks are calculated as follows:
    // 1. At same weight, Bench mark = target reps
    // 2. At a lower weight, Bench mark = target reps * 1.15
    // 3. At a higher weight, Bench mark = target reps * 0.85
    // We then generate the next sets using the progressive overload logic:
    // We will aim to increase the actualReps to the upper bound of the excerciseRepRange (stored in excerciseMetadata).
    // The default range is 4 - 8 reps
    // Once user hits upperBound of the excerciseRepRange, we will increase the weight by 2.5kg and continue the cycle.
    // How the sets are progressively overloaded:
    // 1. Failed => maintain the actual reps and actual weight of that set
    // 2. Higher => maintain the actual reps and actual weight of that set + 1
    // 3. Maintain => increase by 1 rep
    // 4. Did not complete (Empty set) => reduce the total reps by 10%
    //Check for empty sets
    var haveEmptySet = false;
    for (let excercise_set of excercise_sets) {
        if (excercise_set.actual_reps == null ||
            excercise_set.actual_weight == null) {
            haveEmptySet = true;
            break;
        }
    }
    // Create subsequent sets
    for (let excercise_set of excercise_sets) {
        if (excercise_set.actual_reps != null ||
            excercise_set.actual_weight != null) {
            const { actual_reps, actual_weight, excercise_set_id, workout_id } = excercise_set, excercise_set_scaffold = __rest(excercise_set, ["actual_reps", "actual_weight", "excercise_set_id", "workout_id"]);
            if (rateExcerciseSet(excercise_set) == "FAILED") {
                // 1. Failed => maintain the actual reps and actual weight of that set
                new_excercise_sets.push(excercise_set_scaffold);
            }
            else if (rateExcerciseSet(excercise_set) == "EXCEED" ||
                rateExcerciseSet(excercise_set) == "MAINTAINED") {
                // 2. Higher => maintain the actual reps and actual weight of that set + 1
                // 3. Maintain => increase by 1 rep
                // If hit the bound, we will increase weight by 2.5, set the mid point of the rep range
                let newTargetReps = actual_reps + 1;
                let newTargetWeight = actual_weight;
                if (newTargetReps > upperBound) {
                    // hit the upper bound, recalibrate
                    newTargetReps = (lowerBound + upperBound) / 2;
                    newTargetWeight = actual_weight + 2.5;
                }
                excercise_set_scaffold.target_reps = newTargetReps;
                excercise_set_scaffold.target_weight = newTargetWeight;
                new_excercise_sets.push(excercise_set_scaffold);
            }
        }
    }
    // Create the workout and slot behind the rest of the queue.
    const active_workouts = yield prisma.workout.findMany({
        where: {
            date_completed: null,
            workoutGroup: {
                user_id: context.user.user_id,
            },
        },
        orderBy: {
            order_index: "asc",
        },
    });
    yield prisma.workout.create({
        data: {
            workout_group_id: workout_group_id,
            order_index: active_workouts.length,
            excercise_sets: {
                create: new_excercise_sets,
            },
        },
    });
});
exports.generateNextWorkout = generateNextWorkout;
//# sourceMappingURL=workout_manager.js.map