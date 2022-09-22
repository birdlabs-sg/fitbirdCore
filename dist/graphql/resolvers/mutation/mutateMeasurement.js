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
exports.deleteMeasurement = exports.updateMeasurement = exports.createMeasurement = void 0;
const apollo_server_1 = require("apollo-server");
const firebase_service_1 = require("../../../service/firebase/firebase_service");
const createMeasurement = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const prisma = context.dataSources.prisma;
    const { muscle_region_id } = args, otherArgs = __rest(args, ["muscle_region_id"]);
    const newMeasurement = yield prisma.measurement.create({
        data: Object.assign(Object.assign({}, otherArgs), { muscle_region: {
                connect: { muscle_region_id: parseInt(muscle_region_id) },
            }, user: {
                connect: { user_id: context.user.user_id },
            } }),
        include: {
            muscle_region: true,
        },
    });
    return {
        code: "200",
        success: true,
        message: "Successfully recorded your measurement!",
        measurement: newMeasurement,
    };
});
exports.createMeasurement = createMeasurement;
const updateMeasurement = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const { measurement_id } = args, otherArgs = __rest(args, ["measurement_id"]);
    const prisma = context.dataSources.prisma;
    // conduct check that the measurement object belongs to the user.
    const targetMeasurement = yield prisma.measurement.findUnique({
        where: {
            measurement_id: parseInt(measurement_id),
        },
    });
    if (targetMeasurement != null &&
        targetMeasurement.user_id !== context.user.user_id) {
        throw new apollo_server_1.ForbiddenError("You are not authororized to mutate this object.");
    }
    const updatedMeasurement = yield prisma.measurement.update({
        where: {
            measurement_id: parseInt(measurement_id),
        },
        data: otherArgs,
        include: {
            muscle_region: true,
        },
    });
    return {
        code: "200",
        success: true,
        message: "Successfully updated your measurement!",
        measurement: updatedMeasurement,
    };
});
exports.updateMeasurement = updateMeasurement;
const deleteMeasurement = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const prisma = context.dataSources.prisma;
    const { measurement_id } = args;
    // conduct check that the measurement object belongs to the user.
    const targetMeasurement = yield prisma.measurement.findUnique({
        where: {
            measurement_id: parseInt(measurement_id),
        },
    });
    if (targetMeasurement != null &&
        targetMeasurement.user_id !== context.user.user_id) {
        throw new apollo_server_1.ForbiddenError("You are not authororized to remove this object.");
    }
    const deletedMeasurement = yield prisma.measurement.delete({
        where: {
            measurement_id: parseInt(measurement_id),
        },
    });
    return {
        code: "200",
        success: true,
        message: "Successfully removed your measurement!",
        measurement: deletedMeasurement,
    };
});
exports.deleteMeasurement = deleteMeasurement;
//# sourceMappingURL=mutateMeasurement.js.map