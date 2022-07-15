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
exports.deleteExcercise = exports.updateExcercise = exports.createExcercise = void 0;
const firebase_service_1 = require("../../../service/firebase_service");
const createExcercise = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    (0, firebase_service_1.onlyAdmin)(context);
    const prisma = context.dataSources.prisma;
    const { target_regions, synergist_muscles, dynamic_stabilizer_muscles, stabilizer_muscles } = args, otherArgs = __rest(args, ["target_regions", "synergist_muscles", "dynamic_stabilizer_muscles", "stabilizer_muscles"]);
    const targetRegionArray = target_regions.map((target_region_id) => ({
        muscle_region_id: target_region_id,
    }));
    const synergistMusclesArray = synergist_muscles.map((synergist_muscles_id) => ({ muscle_region_id: synergist_muscles_id }));
    const dynamicStabilizerMusclesArray = dynamic_stabilizer_muscles.map((dynamic_stabilizer_muscles_id) => ({
        muscle_region_id: dynamic_stabilizer_muscles_id,
    }));
    const stabilizerMusclesArray = stabilizer_muscles.map((stabilizer_muscles_id) => ({
        muscle_region_id: stabilizer_muscles_id,
    }));
    const newExcercise = yield prisma.excercise.create({
        data: Object.assign(Object.assign({}, otherArgs), { target_regions: {
                connect: targetRegionArray,
            }, stabilizer_muscles: {
                connect: stabilizerMusclesArray,
            }, synergist_muscles: {
                connect: synergistMusclesArray,
            }, dynamic_stabilizer_muscles: {
                connect: dynamicStabilizerMusclesArray,
            } }),
        include: {
            target_regions: true,
            stabilizer_muscles: true,
            synergist_muscles: true,
            dynamic_stabilizer_muscles: true,
        },
    });
    return {
        code: "200",
        success: true,
        message: "Successfully created an excercise!",
        excercise: newExcercise,
    };
});
exports.createExcercise = createExcercise;
const updateExcercise = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    (0, firebase_service_1.onlyAdmin)(context);
    const prisma = context.dataSources.prisma;
    const { excercise_id, target_regions, synergist_muscles, dynamic_stabilizer_muscles, stabilizer_muscles } = args, otherArgs = __rest(args, ["excercise_id", "target_regions", "synergist_muscles", "dynamic_stabilizer_muscles", "stabilizer_muscles"]);
    const targetRegionArray = target_regions.map((target_region_id) => ({
        muscle_region_id: target_region_id,
    }));
    const synergistMusclesArray = synergist_muscles.map((synergist_muscles_id) => ({ muscle_region_id: synergist_muscles_id }));
    const dynamicStabilizerMusclesArray = dynamic_stabilizer_muscles.map((dynamic_stabilizer_muscles_id) => ({
        muscle_region_id: dynamic_stabilizer_muscles_id,
    }));
    const stabilizerMusclesArray = stabilizer_muscles.map((stabilizer_muscles_id) => ({
        muscle_region_id: stabilizer_muscles_id,
    }));
    const updatedExcercise = yield prisma.excercise.update({
        where: {
            excercise_id: excercise_id,
        },
        data: Object.assign(Object.assign({}, otherArgs), { target_regions: {
                set: targetRegionArray,
            }, stabilizer_muscles: {
                set: stabilizerMusclesArray,
            }, synergist_muscles: {
                set: synergistMusclesArray,
            }, dynamic_stabilizer_muscles: {
                set: dynamicStabilizerMusclesArray,
            } }),
        include: {
            target_regions: true,
            stabilizer_muscles: true,
            synergist_muscles: true,
            dynamic_stabilizer_muscles: true,
        },
    });
    return {
        code: "200",
        success: true,
        message: "Successfully updated the specified excercise!",
        excercise: updatedExcercise,
    };
});
exports.updateExcercise = updateExcercise;
const deleteExcercise = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    (0, firebase_service_1.onlyAdmin)(context);
    const prisma = context.dataSources.prisma;
    const deletedExcercise = yield prisma.excercise.delete({
        where: {
            excercise_id: args.excercise_id,
        },
    });
    return {
        code: "200",
        success: true,
        message: "Successfully deleted the specified excercise.",
        excercise: deletedExcercise,
    };
});
exports.deleteExcercise = deleteExcercise;
//# sourceMappingURL=mutateExcercise.js.map