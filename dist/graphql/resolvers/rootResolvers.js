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
const mutateBroadcast_1 = require("./mutation/mutateBroadcast");
const mutateExcercise_1 = require("./mutation/mutateExcercise");
const mutateExcerciseBlock_1 = require("./mutation/mutateExcerciseBlock");
const mutateMeasurement_1 = require("./mutation/mutateMeasurement");
const mutateMuscleRegion_1 = require("./mutation/mutateMuscleRegion");
const mutateWorkout_1 = require("./mutation/mutateWorkout");
const mutateSignup_1 = require("./mutation/mutateSignup");
const queryBroadcasts_1 = require("./query/queryBroadcasts");
const queryExcercises_1 = require("./query/queryExcercises");
const queryNotifications_1 = require("./query/queryNotifications");
const queryUser_1 = require("./query/queryUser");
const queryWorkouts_1 = require("./query/queryWorkouts");
exports.resolvers = {
    //Mutations for create, update and delete operations
    Mutation: {
        signup: mutateSignup_1.mutateSignup,
        generateFirebaseIdToken: generateFirebaseIdTokenResolver_1.generateFirebaseIdTokenResolver,
        createMeasurement: mutateMeasurement_1.createMeasurement,
        updateMeasurement: mutateMeasurement_1.updateMeasurement,
        deleteMeasurement: mutateMeasurement_1.deleteMeasurement,
        createBroadcast: mutateBroadcast_1.createBroadcast,
        updateBroadcast: mutateBroadcast_1.updateBroadcast,
        deleteBroadcast: mutateBroadcast_1.deleteBroadcast,
        createExcercise: mutateExcercise_1.createExcercise,
        updateExcercise: mutateExcercise_1.updateExcercise,
        deleteExcercise: mutateExcercise_1.deleteExcercise,
        createExcerciseBlock: mutateExcerciseBlock_1.createExcerciseBlock,
        updateExcerciseBlock: mutateExcerciseBlock_1.updateExcerciseBlock,
        deleteExcerciseBlock: mutateExcerciseBlock_1.deleteExcerciseBlock,
        createWorkout: mutateWorkout_1.createWorkout,
        updateWorkout: mutateWorkout_1.updateWorkout,
        deleteWorkout: mutateWorkout_1.deleteWorkout,
        createMuscleRegion: mutateMuscleRegion_1.createMuscleRegion,
        updateMuscleRegion: mutateMuscleRegion_1.updateMuscleRegion,
        deleteMuscleRegion: mutateMuscleRegion_1.deleteMuscleRegion,
    },
    //Root Query: Top level querying logic here
    Query: {
        user: queryUser_1.userQueryResolvers,
        workouts: queryWorkouts_1.workoutsQueryResolver,
        excercises: queryExcercises_1.excercisesQueryResolver,
        broadcasts: queryBroadcasts_1.broadCastsQueryResolver,
        notifications: queryNotifications_1.notificationsQueryResolver,
        users: queryUser_1.userQueryResolvers,
    },
    // Individual model querying here.
    User: {
        measurements(parent, args, context, info) {
            return __awaiter(this, void 0, void 0, function* () {
                const prisma = context.dataSources.prisma;
                return yield prisma.measurement.findMany({
                    where: {
                        user_id: parent.user_id
                    },
                    include: {
                        muscle_region: true
                    }
                });
            });
        },
        workouts(parent, args, context, info) {
            return __awaiter(this, void 0, void 0, function* () {
                const prisma = context.dataSources.prisma;
                return yield prisma.workout.findMany({
                    where: {
                        user_id: parent.user_id
                    }
                });
            });
        },
        notifications(parent, args, context, info) {
            return __awaiter(this, void 0, void 0, function* () {
                const prisma = context.dataSources.prisma;
                return yield prisma.notification.findMany({
                    where: {
                        user_id: parent.user_id
                    }
                });
            });
        },
        broadcasts(parent, args, context, info) {
            return __awaiter(this, void 0, void 0, function* () {
                const prisma = context.dataSources.prisma;
                return yield prisma.broadCast.findMany({
                    where: {
                        users: {
                            some: {
                                user_id: parent.user_id
                            }
                        }
                    }
                });
            });
        }
    },
    Workout: {
        excercise_blocks(parent, args, context, info) {
            return __awaiter(this, void 0, void 0, function* () {
                const prisma = context.dataSources.prisma;
                return yield prisma.excerciseBlock.findMany({
                    where: { workout_id: parent.workout_id }
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
                        excercises: {
                            some: { excercise_id: parent.excercise_id }
                        }
                    }
                });
            });
        },
    },
    BroadCast: {
        users(parent, args, context, info) {
            return __awaiter(this, void 0, void 0, function* () {
                const prisma = context.dataSources.prisma;
                return yield prisma.user.findMany({
                    where: {
                        broadcasts: {
                            some: { broad_cast_id: parent.broad_cast_id }
                        }
                    }
                });
            });
        },
    },
};
//# sourceMappingURL=rootResolvers.js.map