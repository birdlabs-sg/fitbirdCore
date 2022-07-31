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
exports.deleteWorkout = exports.updateWorkout = exports.completeWorkout = exports.updateWorkoutOrder = exports.createWorkout = exports.generateWorkouts = void 0;
const workout_manager_1 = require("../../../service/workout_manager");
const firebase_service_1 = require("../../../service/firebase_service");
const util = require("util");
const generateWorkouts = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const { no_of_workouts } = args;
    const prisma = context.dataSources.prisma;
    const generatedWorkouts = [];
    // Just a mockup for now. TODO: Create a service that links up with lichuan's recommendation algorithm
    for (let i = 0; i < no_of_workouts; i++) {
        generatedWorkouts.push(yield prisma.workout.create({
            data: {
                user_id: context.user.user_id,
                order_index: yield (0, workout_manager_1.getActiveWorkoutCount)(context),
                life_span: 25,
                workout_name: `Test workout: ${i}`,
                excercise_sets: {
                    create: [
                        {
                            target_reps: 10,
                            target_weight: 80,
                            weight_unit: "KG",
                            excercise_name: "Barbell Close Grip Bench Press",
                            actual_weight: null,
                            actual_reps: null,
                        },
                        {
                            target_reps: 10,
                            target_weight: 80,
                            weight_unit: "KG",
                            excercise_name: "Barbell Close Grip Bench Press",
                            actual_weight: null,
                            actual_reps: null,
                        },
                        {
                            target_reps: 30,
                            target_weight: 5,
                            weight_unit: "KG",
                            excercise_name: "Machine-assisted Triceps Dip",
                            actual_reps: null,
                            actual_weight: null,
                        },
                    ],
                },
            },
            include: {
                excercise_sets: true,
            },
        }));
    }
    return generatedWorkouts;
});
exports.generateWorkouts = generateWorkouts;
// Note: This resolver is only used when the user wishes to create new workout on existing ones.
// Assumption: active_workouts always have order_index with no gaps when sorted. For eg: 0,1,2,3 and not 0,2,3,5
const createWorkout = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const prisma = context.dataSources.prisma;
    const { excercise_set_groups } = args, otherArgs = __rest(args, ["excercise_set_groups"]);
    // Ensure that there is a max of 7 workouts
    if ((yield (0, workout_manager_1.getActiveWorkoutCount)(context)) > 6) {
        throw Error("You can only have 7 active workouts.");
    }
    const formattedExcerciseSetGroups = (0, workout_manager_1.formatExcerciseSetGroups)(excercise_set_groups);
    const workout = yield prisma.workout.create({
        data: Object.assign(Object.assign({ user_id: context.user.user_id, order_index: yield (0, workout_manager_1.getActiveWorkoutCount)(context) }, otherArgs), { excercise_set_groups: {
                create: formattedExcerciseSetGroups,
            } }),
        include: {
            excercise_set_groups: {
                include: { excercise_sets: true },
            },
        },
    });
    yield (0, workout_manager_1.generateExcerciseMetadata)(context, workout);
    return {
        code: "200",
        success: true,
        message: "Successfully created a workout.",
        workout: workout,
    };
});
exports.createWorkout = createWorkout;
// Assumption: active_workouts always have order_index with no gaps when sorted. For eg: 0,1,2,3 and not 0,2,3,5
const updateWorkoutOrder = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    let { oldIndex, newIndex } = args;
    yield (0, workout_manager_1.reorderActiveWorkouts)(context, oldIndex, newIndex);
    return {
        code: "200",
        success: true,
        message: "Successfully updated your workout!",
        workouts: yield (0, workout_manager_1.getActiveWorkouts)(context),
    };
});
exports.updateWorkoutOrder = updateWorkoutOrder;
// Note: Client have to send in all the excercise_sets or it will be treated that the excercise_set is to be deleted
const completeWorkout = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const { workout_id, excercise_set_groups } = args;
    const prisma = context.dataSources.prisma;
    yield (0, workout_manager_1.checkExistsAndOwnership)(context, workout_id, false);
    console.log("EXCERCISE SET GROUPS: ", util.inspect(excercise_set_groups, false, true, true));
    const [current_workout_excercise_group_sets, next_workout_excercise_group_sets,] = (0, workout_manager_1.excerciseSetGroupsTransformer)(excercise_set_groups);
    console.log(current_workout_excercise_group_sets, "CURRENT");
    console.log(next_workout_excercise_group_sets, "NEXT");
    const completedWorkout = yield prisma.workout.update({
        where: {
            workout_id: parseInt(workout_id),
        },
        data: {
            date_completed: new Date(),
            excercise_set_groups: {
                deleteMany: {},
                create: (0, workout_manager_1.formatExcerciseSetGroups)(current_workout_excercise_group_sets),
            },
        },
        include: {
            excercise_set_groups: { include: { excercise_sets: true } },
        },
    });
    yield (0, workout_manager_1.generateExcerciseMetadata)(context, completedWorkout);
    yield (0, workout_manager_1.updateExcerciseMetadataWithCompletedWorkout)(context, completedWorkout);
    yield (0, workout_manager_1.reorderActiveWorkouts)(context, null, null);
    yield (0, workout_manager_1.generateNextWorkout)(context, completedWorkout, next_workout_excercise_group_sets);
    console.log("here7");
    return {
        code: "200",
        success: true,
        message: "Successfully updated your workout!",
        workout_id: workout_id,
        workouts: yield (0, workout_manager_1.getActiveWorkouts)(context),
    };
});
exports.completeWorkout = completeWorkout;
// Note: Client have to send in all the excercise_sets with associated data or it will be treated that the excercise_set is to be deleted
// Note: This only allows active workouts
const updateWorkout = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const { workout_id, excercise_set_groups } = args, otherArgs = __rest(args, ["workout_id", "excercise_set_groups"]);
    const prisma = context.dataSources.prisma;
    yield (0, workout_manager_1.checkExistsAndOwnership)(context, workout_id, false);
    let updatedData = Object.assign(Object.assign({}, otherArgs), (excercise_set_groups && {
        excercise_set_groups: {
            deleteMany: {},
            create: (0, workout_manager_1.formatExcerciseSetGroups)(excercise_set_groups),
        },
    }));
    const updatedWorkout = yield prisma.workout.update({
        where: {
            workout_id: parseInt(workout_id),
        },
        data: updatedData,
        include: {
            excercise_set_groups: { include: { excercise_sets: true } },
        },
    });
    yield (0, workout_manager_1.generateExcerciseMetadata)(context, updatedWorkout);
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
    yield (0, workout_manager_1.checkExistsAndOwnership)(context, args.workout_id, false);
    console.log("here! deleted");
    // delete the workout
    yield prisma.workout.delete({
        where: {
            workout_id: parseInt(args.workout_id),
        },
    });
    console.log("here! deleted");
    // reorder remaining workouts
    yield (0, workout_manager_1.reorderActiveWorkouts)(context, null, null);
    return {
        code: "200",
        success: true,
        message: "Successfully deleted your workout!",
        workouts: yield (0, workout_manager_1.getActiveWorkouts)(context),
    };
});
exports.deleteWorkout = deleteWorkout;
//# sourceMappingURL=mutateWorkout.js.map