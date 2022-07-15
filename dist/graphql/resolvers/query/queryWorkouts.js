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
exports.workoutsQueryResolver = void 0;
const firebase_service_1 = require("../../../service/firebase_service");
const workoutsQueryResolver = (parent, args, context, info) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const prisma = context.dataSources.prisma;
    switch (args.filter) {
        case "ACTIVE":
            return yield prisma.workout.findMany({
                where: {
                    workoutGroup: {
                        user_id: context.user.user_id,
                    },
                    date_completed: null,
                },
                orderBy: {
                    order_index: "asc",
                },
            });
        case "COMPLETED":
            return yield prisma.workout.findMany({
                where: {
                    workoutGroup: {
                        user_id: context.user.user_id,
                    },
                    date_completed: { not: null },
                },
                orderBy: {
                    date_completed: "asc",
                },
            });
        case "NONE":
            return yield prisma.workout.findMany({
                where: {
                    workoutGroup: {
                        user_id: context.user.user_id,
                    },
                },
            });
    }
});
exports.workoutsQueryResolver = workoutsQueryResolver;
//# sourceMappingURL=queryWorkouts.js.map