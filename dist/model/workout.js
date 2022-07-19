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
exports.checkExistsAndOwnership = exports.getActiveWorkoutCount = exports.getActiveWorkouts = void 0;
const apollo_server_1 = require("apollo-server");
const getActiveWorkouts = (context) => __awaiter(void 0, void 0, void 0, function* () {
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
exports.getActiveWorkouts = getActiveWorkouts;
const getActiveWorkoutCount = (context) => __awaiter(void 0, void 0, void 0, function* () {
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
exports.getActiveWorkoutCount = getActiveWorkoutCount;
const checkExistsAndOwnership = (context, targetWorkout) => {
    if (targetWorkout == null) {
        throw new Error("The workout does not exist.");
    }
    if (targetWorkout.user_id != context.user.user_id) {
        throw new apollo_server_1.AuthenticationError("You are not authorized to remove this object");
    }
};
exports.checkExistsAndOwnership = checkExistsAndOwnership;
//# sourceMappingURL=workout.js.map