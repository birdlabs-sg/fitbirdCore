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
exports.excercisesQueryResolver = void 0;
const client_1 = require("@prisma/client");
const _ = require("lodash");
const excercisesQueryResolver = (parent, args, context, info) => __awaiter(void 0, void 0, void 0, function* () {
    const prisma = context.dataSources.prisma;
    const user_constaints = _.differenceWith(Object.keys(client_1.Equipment), context.user.equipment_accessible, _.isEqual);
    const filteredExcercises = yield prisma.excercise.findMany({
        where: {
            NOT: {
                equipment_required: {
                    hasSome: user_constaints,
                },
            },
        },
    });
    return filteredExcercises;
});
exports.excercisesQueryResolver = excercisesQueryResolver;
//# sourceMappingURL=queryExcercises.js.map