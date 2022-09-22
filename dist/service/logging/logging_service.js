"use strict";
// A GraphQLExtension that implements the existing logFunction interface. Note
// that now that custom extensions are supported, you may just want to do your
// logging as a GraphQLExtension rather than write a LogFunction.
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
exports.logger = void 0;
exports.logger = {
    serverWillStart() {
        return __awaiter(this, void 0, void 0, function* () {
            console.log("🚀  Server initializing...");
        });
    },
    requestDidStart(requestContext) {
        return __awaiter(this, void 0, void 0, function* () {
            if (requestContext.request.operationName !== "IntrospectionQuery") {
                console.log(`[REQUEST] ${new Date()}`);
            }
            return {
                parsingDidStart() {
                    return __awaiter(this, void 0, void 0, function* () {
                        return (err) => __awaiter(this, void 0, void 0, function* () {
                            if (err) {
                                console.error(err);
                            }
                        });
                    });
                },
                validationDidStart() {
                    return __awaiter(this, void 0, void 0, function* () {
                        // This end hook is unique in that it can receive an array of errors,
                        // which will contain every validation error that occurred.
                        return (errs) => __awaiter(this, void 0, void 0, function* () {
                            if (errs) {
                                errs.forEach((err) => console.error(err));
                            }
                        });
                    });
                },
                executionDidStart() {
                    return __awaiter(this, void 0, void 0, function* () {
                        return {
                            executionDidEnd(err) {
                                return __awaiter(this, void 0, void 0, function* () {
                                    if (err) {
                                        console.error(err);
                                    }
                                });
                            },
                        };
                    });
                },
                willSendResponse(context) {
                    return __awaiter(this, void 0, void 0, function* () {
                        if (context.request.operationName !== "IntrospectionQuery") {
                            console.log(`[RESPONSE] ${new Date()}`);
                        }
                    });
                },
            };
        });
    },
};
//# sourceMappingURL=logging_service.js.map