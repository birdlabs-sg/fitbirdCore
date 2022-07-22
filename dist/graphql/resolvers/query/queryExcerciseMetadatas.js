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
exports.getExcerciseMetadatasQueryResolver = void 0;
const getExcerciseMetadatasQueryResolver = (parent, args, context, info) => __awaiter(void 0, void 0, void 0, function* () {
    const prisma = context.dataSources.prisma;
    const { excercise_names_list } = args;
    return yield prisma.excerciseMetadata.findMany({
        where: {
            user_id: context.user.user_id,
            excercise_name: {
                in: excercise_names_list[0],
            },
        },
    });
});
exports.getExcerciseMetadatasQueryResolver = getExcerciseMetadatasQueryResolver;
//# sourceMappingURL=queryExcerciseMetadatas.js.map