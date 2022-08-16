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
exports.generateNotificationResolver = void 0;
const firebase_service_1 = require("../../../service/firebase_service");
const notification_service_1 = require("../../../service/notification_service");
const generateNotificationResolver = (_, args, context) => __awaiter(void 0, void 0, void 0, function* () {
    (0, firebase_service_1.onlyAuthenticated)(context);
    const { token, title, body } = args;
    const notificationLog = yield (0, notification_service_1.generateNotification)(token, title, body);
    console.log(`generated: ${notificationLog}`);
    return {
        code: "200",
        success: true,
        message: "Successfully generated notification",
    };
});
exports.generateNotificationResolver = generateNotificationResolver;
//# sourceMappingURL=generateNotificationResolver.js.map