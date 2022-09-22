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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.workoutFrequencyQueryResolver = void 0;
const moment_1 = __importDefault(require("moment"));
const firebase_service_1 = require("../../../service/firebase/firebase_service");
const workoutFrequencyQueryResolver = (_, __, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const prisma = context.dataSources.prisma;
    function getWeekRange(week = 1) {
        var weekStart = (0, moment_1.default)().add(week, "weeks").startOf("week");
        var weekEnd = (0, moment_1.default)().add(week, "weeks").endOf("week");
        return { startDate: weekStart.toDate(), endDate: weekEnd.toDate() };
    }
    const workoutFrequencies = [];
    for (let i = 0; i > -6; i--) {
        const { startDate, endDate } = getWeekRange(i);
        const count = yield prisma.workout.aggregate({
            _count: true,
            where: {
                user_id: context.user.user_id,
                date_completed: {
                    gte: startDate,
                    lt: endDate,
                },
            },
        });
        workoutFrequencies.unshift({
            workout_count: count._count,
            week_identifier: (0, moment_1.default)(startDate).format("MMM DD"),
        });
    }
    return workoutFrequencies;
});
exports.workoutFrequencyQueryResolver = workoutFrequencyQueryResolver;
//# sourceMappingURL=queryWorkoutFrequencies.js.map