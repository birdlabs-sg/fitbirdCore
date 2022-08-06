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
exports.resolvers = void 0;
const generateFirebaseIdTokenResolver_1 = require("./mutation/generateFirebaseIdTokenResolver");
const mutateUser_1 = require("./mutation/mutateUser");
const mutateMeasurement_1 = require("./mutation/mutateMeasurement");
const mutateMuscleRegion_1 = require("./mutation/mutateMuscleRegion");
const mutateWorkout_1 = require("./mutation/mutateWorkout");
const mutateSignup_1 = require("./mutation/mutateSignup");
const queryExcercises_1 = require("./query/queryExcercises");
const queryNotifications_1 = require("./query/queryNotifications");
const queryUser_1 = require("./query/queryUser");
const queryWorkouts_1 = require("./query/queryWorkouts");
const mutateExcerciseMetadata_1 = require("./mutation/mutateExcerciseMetadata");
const queryWorkoutFrequencies_1 = require("./query/queryWorkoutFrequencies");
const queryExcercise_1 = require("./query/queryExcercise");
const queryExcercisePerformance_1 = require("./query/queryExcercisePerformance");
const queryExcerciseMetadatas_1 = require("./query/queryExcerciseMetadatas");
const queryWorkout_1 = require("./query/queryWorkout");
const _ = require("lodash");
exports.resolvers = {
    //Mutations for create, update and delete operations
    Mutation: {
        signup: mutateSignup_1.mutateSignup,
        generateFirebaseIdToken: generateFirebaseIdTokenResolver_1.generateFirebaseIdTokenResolver,
        updateUser: mutateUser_1.updateUser,
        createMeasurement: mutateMeasurement_1.createMeasurement,
        updateMeasurement: mutateMeasurement_1.updateMeasurement,
        deleteMeasurement: mutateMeasurement_1.deleteMeasurement,
        createWorkout: mutateWorkout_1.createWorkout,
        updateWorkout: mutateWorkout_1.updateWorkout,
        deleteWorkout: mutateWorkout_1.deleteWorkout,
        updateWorkoutOrder: mutateWorkout_1.updateWorkoutOrder,
        completeWorkout: mutateWorkout_1.completeWorkout,
        createMuscleRegion: mutateMuscleRegion_1.createMuscleRegion,
        updateMuscleRegion: mutateMuscleRegion_1.updateMuscleRegion,
        deleteMuscleRegion: mutateMuscleRegion_1.deleteMuscleRegion,
        updateExcerciseMetadata: mutateExcerciseMetadata_1.updateExcerciseMetadata,
        generateWorkouts: mutateWorkout_1.generateWorkouts,
    },
    //Root Query: Top level querying logic here
    Query: {
        user: queryUser_1.userQueryResolvers,
        workouts: queryWorkouts_1.workoutsQueryResolver,
        getWorkout: queryWorkout_1.workoutQueryResolver,
        getExcercise: queryExcercise_1.getExcerciseQueryResolver,
        excercises: queryExcercises_1.excercisesQueryResolver,
        notifications: queryNotifications_1.notificationsQueryResolver,
        users: queryUser_1.userQueryResolvers,
        workout_frequencies: queryWorkoutFrequencies_1.workoutFrequencyQueryResolver,
        getExcercisePerformance: queryExcercisePerformance_1.excercisePerformanceQueryResolver,
        getExcerciseMetadatas: queryExcerciseMetadatas_1.getExcerciseMetadatasQueryResolver,
    },
    // workout query
    Workout: {
        excercise_set_groups(parent, args, context, info) {
            return __awaiter(this, void 0, void 0, function* () {
                const prisma = context.dataSources.prisma;
                return yield prisma.excerciseSetGroup.findMany({
                    where: { workout_id: parent.workout_id },
                });
            });
        },
    },
    ExcerciseSetGroup: {
        excercise(parent, args, context, info) {
            return __awaiter(this, void 0, void 0, function* () {
                const prisma = context.dataSources.prisma;
                return yield prisma.excercise.findUnique({
                    where: {
                        excercise_name: parent.excercise_name,
                    },
                });
            });
        },
        excerciseMetadata(parent, args, context, info) {
            return __awaiter(this, void 0, void 0, function* () {
                const prisma = context.dataSources.prisma;
                return yield prisma.excerciseMetadata.findUnique({
                    where: {
                        user_id_excercise_name: {
                            user_id: context.user.user_id,
                            excercise_name: parent.excercise_name,
                        },
                    },
                });
            });
        },
        excercise_sets(parent, args, context, info) {
            return __awaiter(this, void 0, void 0, function* () {
                const prisma = context.dataSources.prisma;
                return yield prisma.excerciseSet.findMany({
                    where: {
                        excercise_set_group_id: parent.excercise_set_group_id,
                    },
                });
            });
        },
    },
    Excercise: {
        target_regions(parent, args, context, info) {
            return __awaiter(this, void 0, void 0, function* () {
                const prisma = context.dataSources.prisma;
                return yield prisma.muscleRegion.findMany({
                    where: {
                        target_muscles: {
                            some: { excercise_name: parent.excercise_name },
                        },
                    },
                });
            });
        },
        stabilizer_muscles(parent, args, context, info) {
            return __awaiter(this, void 0, void 0, function* () {
                const prisma = context.dataSources.prisma;
                return yield prisma.muscleRegion.findMany({
                    where: {
                        stabilizer_muscles: {
                            some: { excercise_name: parent.excercise_name },
                        },
                    },
                });
            });
        },
        synergist_muscles(parent, args, context, info) {
            return __awaiter(this, void 0, void 0, function* () {
                const prisma = context.dataSources.prisma;
                return yield prisma.muscleRegion.findMany({
                    where: {
                        synergist_muscles: {
                            some: { excercise_name: parent.excercise_name },
                        },
                    },
                });
            });
        },
        dynamic_stabilizer_muscles(parent, args, context, info) {
            return __awaiter(this, void 0, void 0, function* () {
                const prisma = context.dataSources.prisma;
                return yield prisma.muscleRegion.findMany({
                    where: {
                        dynamic_stabilizer_muscles: {
                            some: { excercise_name: parent.excercise_name },
                        },
                    },
                });
            });
        },
        excercise_metadata(parent, args, context, info) {
            return __awaiter(this, void 0, void 0, function* () {
                const prisma = context.dataSources.prisma;
                return yield prisma.excerciseMetadata.findUnique({
                    where: {
                        user_id_excercise_name: {
                            user_id: context.user.user_id,
                            excercise_name: parent.excercise_name,
                        },
                    },
                });
            });
        },
    },
};
//# sourceMappingURL=rootResolvers.js.map