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
exports.deleteWorkout = exports.updateWorkout = exports.createWorkout = void 0;
const apollo_server_1 = require("apollo-server");
const firebase_service_1 = require("../../../service/firebase_service");
const createWorkout = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const prisma = context.dataSources.prisma;
    const { excercise_blocks } = args, otherArgs = __rest(args, ["excercise_blocks"]);
    const newWorkout = yield prisma.workout.create({
        data: Object.assign(Object.assign({ user_id: context.user.user_id }, otherArgs), { excercise_block: {
                create: excercise_blocks
            } }),
        include: {
            excercise_block: true,
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
    (0, firebase_service_1.onlyAuthenticated)(context);
    const { workout_id } = args, otherArgs = __rest(args, ["workout_id"]);
    const prisma = context.dataSources.prisma;
    // conduct check that the measurement object belongs to the user.
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
        data: otherArgs,
        include: {
            excercise_block: true,
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
    if (targetWorkout.user_id !== context.user.user_id) {
        throw new apollo_server_1.ForbiddenError('You are not authororized to remove this object.');
    }
    const deletedWorkout = yield prisma.workout.delete({
        where: {
            workout_id: args.workout_id,
        },
    });
    return {
        code: "200",
        success: true,
        message: "Successfully deleted your workout!",
        workout: deletedWorkout
    };
});
exports.deleteWorkout = deleteWorkout;
//# sourceMappingURL=mutateWorkout.js.map