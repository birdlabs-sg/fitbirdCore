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
exports.excercisePerformanceQueryResolver = void 0;
const firebase_service_1 = require("../../../service/firebase_service");
const excercisePerformanceQueryResolver = (parent, args, context, info) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const prisma = context.dataSources.prisma;
    let { excercise_name, span } = args;
    if (span == null) {
        span = 1;
    }
    const grouped_excercise_sets = [];
    const excerciseSetGroups = yield prisma.excerciseSetGroup.findMany({
        where: {
            workout: {
                user_id: context.user.user_id,
                date_completed: { not: null },
            },
            excercise_name: excercise_name,
        },
        include: { workout: true, excercise_sets: true },
        take: span,
    });
    for (var excerciseSetGroup of excerciseSetGroups) {
        grouped_excercise_sets.push({
            date_completed: excerciseSetGroup.workout.date_completed,
            excercise_sets: excerciseSetGroup.excercise_sets,
        });
    }
    return { grouped_excercise_sets: grouped_excercise_sets };
});
exports.excercisePerformanceQueryResolver = excercisePerformanceQueryResolver;
//# sourceMappingURL=queryExcercisePerformance.js.map