"use strict";
// Retreives the user's exerciseMetadata with respect to the specified exercise.
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
exports.retrieveExerciseMetadata = void 0;
// If does not exists before hand, generate a new one and return that instead.
const retrieveExerciseMetadata = (context, exerciseName) => __awaiter(void 0, void 0, void 0, function* () {
    const prisma = context.dataSources.prisma;
    const excerciseMetadata = yield prisma.excerciseMetadata.findUnique({
        where: {
            user_id_excercise_name: {
                user_id: context.user.user_id,
                excercise_name: exerciseName,
            },
        },
    });
    if (excerciseMetadata) {
        return excerciseMetadata;
    }
    else {
        // generate a new one
        const metadata = yield prisma.excerciseMetadata.create({
            data: {
                user_id: context.user.user_id,
                excercise_name: exerciseName,
            },
        });
        return metadata;
    }
});
exports.retrieveExerciseMetadata = retrieveExerciseMetadata;
//# sourceMappingURL=retrieveExerciseMetadata.js.map