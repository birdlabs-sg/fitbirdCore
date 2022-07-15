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
exports.deleteMuscleRegion = exports.updateMuscleRegion = exports.createMuscleRegion = void 0;
const firebase_service_1 = require("../../../service/firebase_service");
const createMuscleRegion = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    (0, firebase_service_1.onlyAdmin)(context);
    const prisma = context.dataSources.prisma;
    const newMuscleRegion = yield prisma.muscleRegion.create({
        data: args,
    });
    return {
        code: "200",
        success: true,
        message: "Successfully created a muscle region!",
        muscle_region: newMuscleRegion,
    };
});
exports.createMuscleRegion = createMuscleRegion;
const updateMuscleRegion = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    (0, firebase_service_1.onlyAdmin)(context);
    const { muscle_region_id } = args, otherArgs = __rest(args, ["muscle_region_id"]);
    const prisma = context.dataSources.prisma;
    const updatedMuscleRegion = yield prisma.muscleRegion.update({
        where: {
            muscle_region_id: muscle_region_id,
        },
        data: otherArgs,
    });
    return {
        code: "200",
        success: true,
        message: "Successfully updated your measurement!",
        muscle_region: updatedMuscleRegion,
    };
});
exports.updateMuscleRegion = updateMuscleRegion;
const deleteMuscleRegion = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    (0, firebase_service_1.onlyAdmin)(context);
    const prisma = context.dataSources.prisma;
    const deletedMuscleRegion = yield prisma.muscleRegion.delete({
        where: {
            muscle_region_id: args.muscle_region_id,
        },
    });
    return {
        code: "200",
        success: true,
        message: "Successfully removed your measurement!",
        muscle_region: deletedMuscleRegion,
    };
});
exports.deleteMuscleRegion = deleteMuscleRegion;
//# sourceMappingURL=mutateMuscleRegion.js.map