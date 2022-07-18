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
const generateWorkouts = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    // custom logic for generating workouts based on user type
});
exports.generateWorkouts = generateWorkouts;
// Note: This resolver is only used when the user wishes to create new workout on existing ones.
// Assumption: active_workouts always have order_index with no gaps when sorted. For eg: 0,1,2,3 and not 0,2,3,5
const createWorkout = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const prisma = context.dataSources.prisma;
    const { excercise_sets, workout_group } = args, otherArgs = __rest(args, ["excercise_sets", "workout_group"]);
    // Format the excercise_sets for prisma creation.
    const cleaned_excercise_sets = (0, workout_manager_1.formatExcerciseSets)(excercise_sets);
    // Get all the active workouts
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
    // Create new workout group
    const workoutGroup = yield prisma.workoutGroup.create({
        data: Object.assign(Object.assign({ user: {
                connect: { user_id: context.user.user_id },
            } }, workout_group), { workouts: {
                create: [
                    Object.assign(Object.assign({ order_index: active_workouts.length }, otherArgs), { excercise_sets: {
                            create: cleaned_excercise_sets,
                        } }),
                ],
            } }),
        include: {
            workouts: true,
        },
    });
    return {
        code: "200",
        success: true,
        message: "Successfully created a workout.",
        workout: workoutGroup.workouts[0],
    };
});
exports.createWorkout = createWorkout;
// Assumption: active_workouts always have order_index with no gaps when sorted. For eg: 0,1,2,3 and not 0,2,3,5
const updateWorkoutOrder = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    let { oldIndex, newIndex } = args;
    const prisma = context.dataSources.prisma;
    yield (0, workout_manager_1.reorderActiveWorkouts)(context, oldIndex, newIndex);
    return {
        code: "200",
        success: true,
        message: "Successfully updated your workout!",
        workouts: yield prisma.workout.findMany({
            where: {
                workoutGroup: {
                    user_id: context.user.user_id,
                },
                date_completed: null,
            },
            orderBy: {
                order_index: "asc",
            },
        }),
    };
});
exports.updateWorkoutOrder = updateWorkoutOrder;
// Note: Client have to send in all the excercise_sets or it will be treated that the excercise_set is to be deleted
const completeWorkout = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const { workout_id, excercise_sets } = args;
    const prisma = context.dataSources.prisma;
    // Get the workout of interest
    const targetWorkout = yield prisma.workout.findUnique({
        where: {
            workout_id: parseInt(workout_id),
        },
        include: {
            workoutGroup: true,
        },
    });
    (0, workout_manager_1.enforceWorkoutExistsAndOwnership)(context, targetWorkout);
    // Format the excercise_sets and remove those that are to be deleted.
    const excercise_sets_to_add = (0, workout_manager_1.formatExcerciseSets)(excercise_sets);
    // Complete the workout object by filling date_completed and new excercise_sets. All excercise sets not present in excercise_sets_to_add will be removed from the relationship.
    const completedWorkout = yield prisma.workout.update({
        where: {
            workout_id: parseInt(workout_id),
        },
        data: {
            date_completed: new Date(),
            excercise_sets: {
                deleteMany: {},
                createMany: { data: excercise_sets_to_add },
            },
        },
        include: {
            excercise_sets: true,
        },
    });
    yield (0, workout_manager_1.reorderActiveWorkouts)(context, null, null);
    yield (0, workout_manager_1.generateNextWorkout)(context, completedWorkout);
    // See if want to return back the reordered workouts or just the updatedWorkout
    return {
        code: "200",
        success: true,
        message: "Successfully updated your workout!",
        workout_id: workout_id,
        workouts: yield prisma.workout.findMany({
            where: {
                date_completed: null,
                workoutGroup: {
                    user_id: context.user.user_id,
                },
            },
            orderBy: {
                order_index: "asc",
            },
            include: {
                excercise_sets: true,
            },
        }),
    };
});
exports.completeWorkout = completeWorkout;
// Note: Client have to send in all the excercise_sets with associated data or it will be treated that the excercise_set is to be deleted
const updateWorkout = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const { workout_id, excercise_sets } = args, otherArgs = __rest(args, ["workout_id", "excercise_sets"]);
    const prisma = context.dataSources.prisma;
    // Get the workout of interest
    const targetWorkout = yield prisma.workout.findUnique({
        where: {
            workout_id: parseInt(workout_id),
        },
        include: {
            workoutGroup: true,
        },
    });
    (0, workout_manager_1.enforceWorkoutExistsAndOwnership)(context, targetWorkout);
    let updatedWorkout;
    if (excercise_sets != null) {
        // Format the excercise_sets and remove those that are to be deleted.
        const excercise_sets_to_add = (0, workout_manager_1.formatExcerciseSets)(excercise_sets);
        // Update the workout object with provided args. All excercise sets not present in excercise_sets_to_add will be removed from the relationship.
        updatedWorkout = yield prisma.workout.update({
            where: {
                workout_id: parseInt(workout_id),
            },
            data: Object.assign(Object.assign({}, otherArgs), { excercise_sets: {
                    deleteMany: {},
                    createMany: { data: excercise_sets_to_add },
                } }),
            include: {
                excercise_sets: true,
            },
        });
    }
    else {
        updatedWorkout = yield prisma.workout.update({
            where: {
                workout_id: parseInt(workout_id),
            },
            data: Object.assign({}, otherArgs),
            include: {
                excercise_sets: true,
            },
        });
    }
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
    const targetWorkout = yield prisma.workout.findUnique({
        where: {
            workout_id: parseInt(args.workout_id),
        },
        include: {
            workoutGroup: true,
        },
    });
    (0, workout_manager_1.enforceWorkoutExistsAndOwnership)(context, targetWorkout);
    // delete the workout
    yield prisma.workout.delete({
        where: {
            workout_id: parseInt(args.workout_id),
        },
    });
    // reorder remaining workouts
    yield (0, workout_manager_1.reorderActiveWorkouts)(context, null, null);
    return {
        code: "200",
        success: true,
        message: "Successfully deleted your workout!",
        workouts: yield prisma.workout.findMany({
            where: {
                date_completed: null,
            },
            orderBy: {
                order_index: "asc",
            },
            include: {
                excercise_sets: true,
            },
        }),
    };
});
exports.deleteWorkout = deleteWorkout;
//# sourceMappingURL=mutateWorkout.js.map