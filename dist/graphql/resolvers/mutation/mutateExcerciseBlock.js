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
exports.deleteExcerciseBlock = exports.updateExcerciseBlock = exports.createExcerciseBlock = void 0;
const firebase_service_1 = require("../../../service/firebase_service");
const createExcerciseBlock = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const prisma = context.dataSources.prisma;
    const newExcerciseBlock = yield prisma.excerciseBlock.create({
        data: args,
        include: {
            workout: true,
            excercise: true,
        }
    });
    return {
        code: "200",
        success: true,
        message: "Successfully created an excercise block",
        excercise_block: newExcerciseBlock
    };
});
exports.createExcerciseBlock = createExcerciseBlock;
const updateExcerciseBlock = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const { workout_id, excercise_id, weight, weight_unit, reps_per_set, sets } = args, otherArgs = __rest(args, ["workout_id", "excercise_id", "weight", "weight_unit", "reps_per_set", "sets"]);
    const prisma = context.dataSources.prisma;
    const updatedExcerciseBlock = yield prisma.excerciseBlock.update({
        where: {
            workout_id_excercise_id_weight_weight_unit_reps_per_set_sets: {
                workout_id: workout_id,
                excercise_id: excercise_id,
                weight: weight,
                weight_unit: weight_unit,
                reps_per_set: reps_per_set,
                sets: sets,
            }
        },
        data: otherArgs,
        include: {
            workout: true,
            excercise: true,
        }
    });
    return {
        code: "200",
        success: true,
        message: "Successfully updated the specified excercise block!",
        excercise_block: updatedExcerciseBlock
    };
});
exports.updateExcerciseBlock = updateExcerciseBlock;
const deleteExcerciseBlock = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const prisma = context.dataSources.prisma;
    const deletedExcerciseBlock = yield prisma.excerciseBlock.delete({
        where: {
            workout_id_excercise_id_weight_weight_unit_reps_per_set_sets: {
                workout_id: args.workout_id,
                excercise_id: args.excercise_id,
                weight: args.weight,
                weight_unit: args.weight_unit,
                reps_per_set: args.reps_per_set,
                sets: args.sets,
            }
        }
    });
    return {
        code: "200",
        success: true,
        message: "Successfully removed the specified excercise block!",
        excercise_block: deletedExcerciseBlock
    };
});
exports.deleteExcerciseBlock = deleteExcerciseBlock;
//# sourceMappingURL=mutateExcerciseBlock.js.map