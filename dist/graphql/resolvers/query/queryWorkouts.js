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
const workoutsQueryResolver = (parent, args, context, info) => __awaiter(void 0, void 0, void 0, function* () {
    // onlyAuthenticated(context)
    const prisma = context.dataSources.prisma;
    console.log(yield prisma.workout.findMany({
        where: {
            user_id: context.user_id
        },
        include: {
            excercise_block: true
        }
    }));
    return yield prisma.workout.findMany({
        where: {
            user_id: context.user_id
        }
    });
});
exports.workoutsQueryResolver = workoutsQueryResolver;
//# sourceMappingURL=queryWorkouts.js.map