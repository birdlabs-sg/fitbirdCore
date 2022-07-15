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
exports.deleteBroadcast = exports.updateBroadcast = exports.createBroadcast = void 0;
const firebase_service_1 = require("../../../service/firebase_service");
const createBroadcast = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    (0, firebase_service_1.onlyAdmin)(context);
    const prisma = context.dataSources.prisma;
    const { users } = args, otherArgs = __rest(args, ["users"]);
    const usersArray = users.map((user_id) => ({ user_id: user_id }));
    const newBroadcast = yield prisma.broadCast.create({
        data: Object.assign(Object.assign({}, otherArgs), { users: {
                connect: usersArray,
            } }),
        include: {
            users: true,
        },
    });
    return {
        code: "200",
        success: true,
        message: "Successfully created a broadcast!",
        broadcast: newBroadcast,
    };
});
exports.createBroadcast = createBroadcast;
const updateBroadcast = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    (0, firebase_service_1.onlyAdmin)(context);
    const prisma = context.dataSources.prisma;
    const { broad_cast_id, users } = args, otherArgs = __rest(args, ["broad_cast_id", "users"]);
    const usersArray = users.map((user_id) => ({ user_id: user_id }));
    const updatedBroadcast = yield prisma.broadCast.update({
        where: {
            broad_cast_id: broad_cast_id,
        },
        data: Object.assign(Object.assign({}, otherArgs), { users: {
                set: usersArray,
            } }),
        include: {
            users: true,
        },
    });
    return {
        code: "200",
        success: true,
        message: "Successfully updated the specified broadcast!",
        broadcast: updatedBroadcast,
    };
});
exports.updateBroadcast = updateBroadcast;
const deleteBroadcast = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    (0, firebase_service_1.onlyAdmin)(context);
    const prisma = context.dataSources.prisma;
    const deletedBroadcast = yield prisma.broadCast.delete({
        where: {
            broad_cast_id: args.broad_cast_id,
        },
    });
    return {
        code: "200",
        success: true,
        message: "Successfully deleted the specified broadcast.",
        broadcast: deletedBroadcast,
    };
});
exports.deleteBroadcast = deleteBroadcast;
//# sourceMappingURL=mutateBroadcast.js.map