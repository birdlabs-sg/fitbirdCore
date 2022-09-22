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
exports.reorderActiveWorkouts = void 0;
/**
 * Reorders the current active set of workouts (AKA current rotation) based on the @oldIndex and @newIndex provided
 * Note:
 * 1. If either @oldindex or no @newIndex is missing, it will just reorder them based on order_index ascending order
 * 2. Reason for this is to reorder the rest because the order was broken (completion, deletion, etc)
 */
function reorderActiveWorkouts(context, oldIndex, newIndex) {
    return __awaiter(this, void 0, void 0, function* () {
        const prisma = context.dataSources.prisma;
        // get all active workouts by their order_index
        const active_workouts = yield prisma.workout.findMany({
            where: {
                date_completed: null,
                user_id: context.user.user_id,
            },
            orderBy: {
                order_index: "asc",
            },
        });
        if (oldIndex != undefined && newIndex != undefined) {
            if (oldIndex < newIndex) {
                newIndex -= 1;
            }
            const workout = active_workouts.splice(oldIndex, 1)[0];
            active_workouts.splice(newIndex, 0, workout);
        }
        for (var i = 0; i < active_workouts.length; i++) {
            const { workout_id } = active_workouts[i];
            yield prisma.workout.update({
                where: {
                    workout_id: workout_id,
                },
                data: {
                    order_index: i,
                },
            });
        }
    });
}
exports.reorderActiveWorkouts = reorderActiveWorkouts;
//# sourceMappingURL=index.js.map