import { generateFirebaseIdTokenResolver } from "./mutation/generateFirebaseIdTokenResolver";
import { createBroadcast, deleteBroadcast, updateBroadcast } from "./mutation/mutateBroadcast";
import { createExcercise, deleteExcercise, updateExcercise } from "./mutation/mutateExcercise";
import { createExcerciseBlock, deleteExcerciseBlock, updateExcerciseBlock } from "./mutation/mutateExcerciseBlock";
import { createMeasurement, deleteMeasurement, updateMeasurement } from "./mutation/mutateMeasurement";
import { createMuscleRegion, deleteMuscleRegion, updateMuscleRegion } from "./mutation/mutateMuscleRegion";
import { createWorkout, deleteWorkout, updateWorkout } from "./mutation/mutateWorkout";
import { mutateSignup } from "./mutation/mutateSignup";
import { broadCastsQueryResolver } from "./query/queryBroadcasts";
import { excercisesQueryResolver } from "./query/queryExcercises";
import { notificationsQueryResolver } from "./query/queryNotifications";
import { userQueryResolvers } from "./query/queryUser";
import { workoutsQueryResolver } from "./query/queryWorkouts";

export const resolvers = {
    //Mutations for create, update and delete operations
    Mutation: {
        signup:  mutateSignup,
        generateFirebaseIdToken:  generateFirebaseIdTokenResolver,
        createMeasurement: createMeasurement,
        updateMeasurement: updateMeasurement,
        deleteMeasurement: deleteMeasurement,
        createBroadcast: createBroadcast,
        updateBroadcast: updateBroadcast,
        deleteBroadcast: deleteBroadcast,
        createExcercise: createExcercise,
        updateExcercise: updateExcercise,
        deleteExcercise: deleteExcercise,
        createExcerciseBlock: createExcerciseBlock,
        updateExcerciseBlock: updateExcerciseBlock,
        deleteExcerciseBlock: deleteExcerciseBlock,
        createWorkout: createWorkout,
        updateWorkout: updateWorkout,
        deleteWorkout: deleteWorkout,
        createMuscleRegion: createMuscleRegion,
        updateMuscleRegion: updateMuscleRegion,
        deleteMuscleRegion: deleteMuscleRegion,
    },
              
    //Root Query: Top level querying logic here
    Query: {
        user: userQueryResolvers,
        workouts: workoutsQueryResolver,
        excercises: excercisesQueryResolver, 
        broadcasts:  broadCastsQueryResolver,
        notifications: notificationsQueryResolver,
        users: userQueryResolvers,
    },

    // Individual model querying here.
    User: {
        async measurements(parent: any, args: any, context: any, info: any){
            const prisma = context.dataSources.prisma
            return await prisma.measurement.findMany({
                where: { 
                    user_id : parent.user_id
                },
                include: {
                    muscle_region: true
                }
            })
        },
        async workouts(parent: any, args: any, context: any, info: any){
            const prisma = context.dataSources.prisma
            return await prisma.workout.findMany({
                where: { 
                    user_id : parent.user_id
                }
            })
        },
        async notifications(parent: any, args: any, context: any, info: any){
            const prisma = context.dataSources.prisma
            return await prisma.notification.findMany({
                where: { 
                    user_id : parent.user_id
                }
            })
        },
        async broadcasts(parent: any, args: any, context: any, info: any){
            const prisma = context.dataSources.prisma
            return await prisma.broadCast.findMany({
                where: {
                    users: {
                        some: {
                            user_id: parent.user_id
                        }
                    }
                }
            })
        }
    },
    Workout: {
        async excercise_blocks(parent: any, args: any, context: any, info: any){
            const prisma = context.dataSources.prisma
            return await prisma.excerciseBlock.findMany({
                where: { workout_id : parent.workout_id }
            })
        },
    },
    Excercise: {
        async target_regions(parent: any, args: any, context: any, info: any){
            const prisma = context.dataSources.prisma
            return await prisma.muscleRegion.findMany({
                where: { 
                    excercises: {
                        some: {excercise_id: parent.excercise_id }
                    } 
                } 
            })
        },
    },
    BroadCast: {
        async users(parent: any, args: any, context: any, info: any){
            const prisma = context.dataSources.prisma
            return await prisma.user.findMany({
                where: { 
                    broadcasts : {
                        some :  { broad_cast_id : parent.broad_cast_id} 
                 }
                }
            })
        },
    },
  };