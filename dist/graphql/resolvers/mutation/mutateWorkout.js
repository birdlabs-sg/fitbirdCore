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
exports.deleteWorkout = exports.updateWorkout = exports.completeWorkout = exports.updateWorkoutOrder = exports.createWorkout = exports.regenerateWorkouts = exports.generateWorkouts = void 0;
const firebase_service_1 = require("../../../service/firebase/firebase_service");
const workout_generator_1 = require("../../../service/workout_manager/workout_generator/workout_generator");
const client_1 = require("@prisma/client");
const utils_1 = require("../../../service/workout_manager/utils");
const workout_order_manager_1 = require("../../../service/workout_manager/workout_order_manager");
const exercise_metadata_manager_1 = require("../../../service/workout_manager/exercise_metadata_manager/exercise_metadata_manager");
const generateWorkouts = (parent, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const { no_of_workouts } = args;
    let generatedWorkouts = yield (0, workout_generator_1.workoutGenerator)(no_of_workouts, context);
    return generatedWorkouts;
});
exports.generateWorkouts = generateWorkouts;
const regenerateWorkouts = (parent, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    (0, firebase_service_1.onlyAuthenticated)(context);
    const prisma = context.dataSources.prisma;
    const no_of_workouts = (_a = context.user.workout_frequency) !== null && _a !== void 0 ? _a : 3;
    const activeWorkouts = yield (0, utils_1.getActiveWorkouts)(context);
    const activeWorkoutIDS = activeWorkouts.map((workout) => workout.workout_id);
    yield prisma.workout.deleteMany({
        where: {
            workout_id: {
                in: activeWorkoutIDS,
            },
        },
    });
    var generatedWorkouts = yield (0, workout_generator_1.workoutGenerator)(no_of_workouts, context);
    return generatedWorkouts;
});
exports.regenerateWorkouts = regenerateWorkouts;
// Note: This resolver is only used when the user wishes to create new workout on existing ones.
// Assumption: active_workouts always have order_index with no gaps when sorted. For eg: 0,1,2,3 and not 0,2,3,5
function createWorkout(parent, args, context) {
    return __awaiter(this, void 0, void 0, function* () {
        (0, firebase_service_1.onlyAuthenticated)(context);
        const prisma = context.dataSources.prisma;
        const { excercise_set_groups } = args, otherArgs = __rest(args, ["excercise_set_groups"]);
        const [excerciseSetGroups, excerciseMetadatas] = (0, utils_1.extractMetadatas)(excercise_set_groups);
        // Ensure that there is a max of 7 workouts
        if ((yield (0, utils_1.getActiveWorkoutCount)(context)) > 6) {
            throw Error("You can only have 7 active workouts.");
        }
        const formattedExcerciseSetGroups = (0, utils_1.formatExcerciseSetGroups)(excerciseSetGroups);
        const workout = yield prisma.workout.create({
            data: Object.assign(Object.assign({ user_id: context.user.user_id, order_index: yield (0, utils_1.getActiveWorkoutCount)(context) }, otherArgs), { excercise_set_groups: {
                    create: formattedExcerciseSetGroups,
                } }),
        });
        yield (0, exercise_metadata_manager_1.generateOrUpdateExcerciseMetadata)(context, excerciseMetadatas);
        return {
            code: "200",
            success: true,
            message: "Successfully created a workout.",
            workout: workout,
        };
    });
}
exports.createWorkout = createWorkout;
// Assumption: active_workouts always have order_index with no gaps when sorted. For eg: 0,1,2,3 and not 0,2,3,5
const updateWorkoutOrder = (parent, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    let { oldIndex, newIndex } = args;
    yield (0, workout_order_manager_1.reorderActiveWorkouts)(context, oldIndex, newIndex);
    return {
        code: "200",
        success: true,
        message: "Successfully updated your workout!",
        workouts: yield (0, utils_1.getActiveWorkouts)(context),
    };
});
exports.updateWorkoutOrder = updateWorkoutOrder;
// Note: Client have to send in all the excercise_sets or it will be treated that the excercise_set is to be deleted
const completeWorkout = (parent, { workout_id, excercise_set_groups }, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const prisma = context.dataSources.prisma;
    yield (0, utils_1.checkExistsAndOwnership)(context, workout_id);
    const [excerciseSetGroups, excerciseMetadatas] = (0, utils_1.extractMetadatas)(excercise_set_groups);
    const [current_workout_excercise_group_sets, next_workout_excercise_group_sets,] = (0, utils_1.exerciseSetGroupStateSeperator)(excerciseSetGroups);
    let completedWorkout;
    completedWorkout = yield prisma.workout.update({
        where: {
            workout_id: parseInt(workout_id),
        },
        data: {
            date_completed: new Date(),
            workout_state: client_1.WorkoutState.COMPLETED,
            excercise_set_groups: {
                deleteMany: {},
                create: (0, utils_1.formatExcerciseSetGroups)(current_workout_excercise_group_sets),
            },
        },
        include: {
            excercise_set_groups: { include: { excercise_sets: true } },
        },
    });
    // in-case there is no associated excercise metadata
    yield (0, exercise_metadata_manager_1.generateOrUpdateExcerciseMetadata)(context, excerciseMetadatas);
    yield (0, exercise_metadata_manager_1.updateExcerciseMetadataWithCompletedWorkout)(context, completedWorkout);
    // this is to reorder the rest before the workout is generated and inserted to the back
    yield (0, workout_order_manager_1.reorderActiveWorkouts)(context, undefined, undefined);
    yield (0, workout_generator_1.generateNextWorkout)(context, completedWorkout, next_workout_excercise_group_sets);
    return {
        code: "200",
        success: true,
        message: "Successfully updated your workout!",
        workouts: yield (0, utils_1.getActiveWorkouts)(context),
    };
});
exports.completeWorkout = completeWorkout;
// Note: Client have to send in all the excercise_sets with associated data or it will be treated that the excercise_set is to be deleted
// Note: This only allows active workouts
const updateWorkout = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const { workout_id, excercise_set_groups } = args, otherArgs = __rest(args, ["workout_id", "excercise_set_groups"]);
    const prisma = context.dataSources.prisma;
    yield (0, utils_1.checkExistsAndOwnership)(context, workout_id);
    let formatedUpdatedData;
    if (excercise_set_groups != null) {
        var [excerciseSetGroups, excercise_metadatas] = (0, utils_1.extractMetadatas)(excercise_set_groups);
        formatedUpdatedData = Object.assign(Object.assign({}, otherArgs), {
            excercise_set_groups: {
                deleteMany: {},
                create: (0, utils_1.formatExcerciseSetGroups)(excerciseSetGroups),
            },
        });
        yield (0, exercise_metadata_manager_1.generateOrUpdateExcerciseMetadata)(context, excercise_metadatas);
    }
    else {
        formatedUpdatedData = Object.assign({}, otherArgs);
    }
    // extract out metadatas
    const updatedWorkout = yield prisma.workout.update({
        where: {
            workout_id: parseInt(workout_id),
        },
        data: formatedUpdatedData,
        include: {
            excercise_set_groups: { include: { excercise_sets: true } },
        },
    });
    return {
        code: "200",
        success: true,
        message: "Successfully updated your workout!",
        workout: updatedWorkout,
    };
});
exports.updateWorkout = updateWorkout;
const deleteWorkout = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const prisma = context.dataSources.prisma;
    // Get the workout of interest
    yield (0, utils_1.checkExistsAndOwnership)(context, args.workout_id);
    // delete the workout
    yield prisma.workout.delete({
        where: {
            workout_id: parseInt(args.workout_id),
        },
    });
    // reorder remaining workouts
    yield (0, workout_order_manager_1.reorderActiveWorkouts)(context, undefined, undefined);
    const activeworkouts = yield (0, utils_1.getActiveWorkouts)(context);
    return {
        code: "200",
        success: true,
        message: "Successfully deleted your workout!",
        workouts: activeworkouts,
    };
});
exports.deleteWorkout = deleteWorkout;
//# sourceMappingURL=mutateWorkout.js.map