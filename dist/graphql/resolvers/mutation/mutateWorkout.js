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
exports.deleteWorkout = exports.updateWorkout = exports.createWorkout = exports.generateWorkouts = void 0;
const apollo_server_1 = require("apollo-server");
const firebase_service_1 = require("../../../service/firebase_service");
const generateWorkouts = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    // custom logic for generating workouts based on user type
});
exports.generateWorkouts = generateWorkouts;
const createWorkout = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    // only used when the user wishes to create new workout on existing ones
    (0, firebase_service_1.onlyAuthenticated)(context);
    const prisma = context.dataSources.prisma;
    const { excercise_sets } = args, otherArgs = __rest(args
    // Get all the active workouts
    , ["excercise_sets"]);
    // Get all the active workouts
    const active_workouts = yield prisma.workout.findMany({
        where: {
            date_completed: null
        },
    });
    // get the highest order index
    var highest_order_index = -1;
    for (var i = 0; i < active_workouts.length; i++) {
        if (active_workouts[i].order_index > highest_order_index) {
            highest_order_index = active_workouts[i].order_index;
        }
    }
    // create a new workout based on provided arguments and slot it behind the last active workout
    const newWorkout = yield prisma.workout.create({
        data: Object.assign(Object.assign({ user_id: context.user.user_id, order_index: highest_order_index + 1 }, otherArgs), { excercise_sets: {
                create: excercise_sets
            } }),
        include: {
            excercise_sets: true,
        }
    });
    return {
        code: "200",
        success: true,
        message: "Successfully created a workout.",
        workout: newWorkout
    };
});
exports.createWorkout = createWorkout;
const updateWorkout = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    // responsibility of reordering is done on the frontend
    (0, firebase_service_1.onlyAuthenticated)(context);
    const { workout_id, excercise_sets } = args, otherArgs = __rest(args, ["workout_id", "excercise_sets"]);
    const prisma = context.dataSources.prisma;
    // note: you have to send in all the excercise_sets cos it'll be if it's not present
    const targetWorkout = yield prisma.workout.findUnique({
        where: {
            workout_id: workout_id
        }
    });
    if (targetWorkout.user_id !== context.user.user_id) {
        throw new apollo_server_1.ForbiddenError('You are not authororized to remove this object.');
    }
    const updatedWorkout = yield prisma.workout.update({
        where: {
            workout_id: workout_id
        },
        data: Object.assign(Object.assign({}, otherArgs), { excercise_sets: {
                deleteMany: {},
                createMany: { data: excercise_sets },
            } }),
        include: {
            excercise_sets: true,
        }
    });
    return {
        code: "200",
        success: true,
        message: "Successfully updated your workout!",
        workout: updatedWorkout
    };
});
exports.updateWorkout = updateWorkout;
const deleteWorkout = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const prisma = context.dataSources.prisma;
    // conduct check that the measurement object belongs to the user.
    const targetWorkout = yield prisma.workout.findUnique({
        where: {
            workout_id: args.workout_id
        }
    });
    if (targetWorkout.user_id != context.user.user_id) {
        throw new apollo_server_1.ForbiddenError('You are not authororized to remove this object.');
    }
    const deletedWorkout = yield prisma.workout.delete({
        where: {
            workout_id: args.workout_id,
        },
    });
    // Reorder the remaining active workouts
    const active_workouts = yield prisma.workout.findMany({
        where: {
            date_completed: null
        },
        orderBy: {
            order_index: 'asc',
        },
    });
    for (var i = 0; i < active_workouts.length; i++) {
        const _a = active_workouts[i], { order_index, workout_id } = _a, otherArgs = __rest(_a, ["order_index", "workout_id"]);
        if (i != order_index) {
            yield prisma.workout.update({
                where: {
                    workout_id: workout_id
                },
                data: Object.assign(Object.assign({ order_index: i }, otherArgs), { excercise_sets: undefined }),
            });
        }
    }
    return {
        code: "200",
        success: true,
        message: "Successfully deleted your workout!",
        workout: deletedWorkout
    };
});
exports.deleteWorkout = deleteWorkout;
//# sourceMappingURL=mutateWorkout.js.map