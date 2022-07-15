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
exports.updateExcerciseMetadata = exports.createExcerciseMetadata = void 0;
const firebase_service_1 = require("../../../service/firebase_service");
const createExcerciseMetadata = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const prisma = context.dataSources.prisma;
    const { excercise_id } = args, otherArgs = __rest(args, ["excercise_id"]);
    const newExcerciseMetadata = yield prisma.excerciseMetadata.create({
        data: Object.assign(Object.assign({}, otherArgs), { excercise: {
                connect: { excercise_id: parseInt(excercise_id) },
            }, user: {
                connect: { user_id: context.user.user_id },
            } }),
    });
    return {
        code: "200",
        success: true,
        message: "Successfully created an excercise metadata!",
        excercise: newExcerciseMetadata,
    };
});
exports.createExcerciseMetadata = createExcerciseMetadata;
const updateExcerciseMetadata = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const prisma = context.dataSources.prisma;
    const { excercise_id } = args, otherArgs = __rest(args, ["excercise_id"]);
    const updatedExcerciseMetadata = yield prisma.excerciseMetadata.update({
        where: {
            user_id_excercise_id: {
                user_id: context.user.user_id,
                excercise_id: parseInt(excercise_id),
            },
        },
        data: Object.assign({}, otherArgs),
    });
    return {
        code: "200",
        success: true,
        message: "Successfully updated the specified excercise metadata!",
        excerciseMetadata: updatedExcerciseMetadata,
    };
});
exports.updateExcerciseMetadata = updateExcerciseMetadata;
//# sourceMappingURL=mutateExcerciseMetadata.js.map