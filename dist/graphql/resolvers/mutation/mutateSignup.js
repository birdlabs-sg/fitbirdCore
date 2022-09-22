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
exports.mutateSignup = void 0;
const firebase_service_1 = require("../../../service/firebase/firebase_service");
const mutateSignup = (_, { email, password, displayName }) => __awaiter(void 0, void 0, void 0, function* () {
    const user = yield (0, firebase_service_1.signupFirebase)(email, password, displayName);
    return {
        code: "200",
        success: true,
        message: "Successfully created an account! Welcome onboard.",
        user: user,
    };
});
exports.mutateSignup = mutateSignup;
//# sourceMappingURL=mutateSignup.js.map