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
exports.usersQueryResolver = void 0;
const firebase_service_1 = require("../../../service/firebase_service");
const firebase_service_2 = require("../../../service/firebase_service");
const usersQueryResolver = (parent, args, context, info) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    (0, firebase_service_2.onlyAdmin)(context);
    const prisma = context.dataSources.prisma;
    // reject non admins. Exception will be thrown if not
    // const requester_user_id = context.user_id
    return yield prisma.user.findMany();
});
exports.usersQueryResolver = usersQueryResolver;
//# sourceMappingURL=queryUsers.js.map