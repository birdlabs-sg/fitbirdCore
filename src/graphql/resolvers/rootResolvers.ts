import { generateFirebaseIdTokenResolver } from "./mutation/generateFirebaseIdTokenResolver";
import { updateUser } from "./mutation/mutateUser";
import {
  createBroadcast,
  deleteBroadcast,
  updateBroadcast,
} from "./mutation/mutateBroadcast";
import {
  createExcercise,
  deleteExcercise,
  updateExcercise,
} from "./mutation/mutateExcercise";
import {
  createMeasurement,
  deleteMeasurement,
  updateMeasurement,
} from "./mutation/mutateMeasurement";
import {
  createMuscleRegion,
  deleteMuscleRegion,
  updateMuscleRegion,
} from "./mutation/mutateMuscleRegion";
import {
  completeWorkout,
  createWorkout,
  deleteWorkout,
  updateWorkout,
  updateWorkoutOrder,
} from "./mutation/mutateWorkout";
import { mutateSignup } from "./mutation/mutateSignup";
import { broadCastsQueryResolver } from "./query/queryBroadcasts";
import { excercisesQueryResolver } from "./query/queryExcercises";
import { notificationsQueryResolver } from "./query/queryNotifications";
import { userQueryResolvers } from "./query/queryUser";
import { workoutsQueryResolver } from "./query/queryWorkouts";
import {
  createExcerciseMetadata,
  updateExcerciseMetadata,
} from "./mutation/mutateExcerciseMetadata";
import { workoutFrequencyQueryResolver } from "./query/queryWorkoutFrequencies";
import { getExcerciseQueryResolver } from "./query/queryExcercise";
import { excercisePerformanceQueryResolver } from "./query/queryExcercisePerformance";
import { getWorkoutsCompletedCountQueryResolver } from "./query/queryWorkoutsCompletedCount";

export const resolvers = {
  //Mutations for create, update and delete operations
  Mutation: {
    signup: mutateSignup,
    generateFirebaseIdToken: generateFirebaseIdTokenResolver,
    updateUser: updateUser,
    createMeasurement: createMeasurement,
    updateMeasurement: updateMeasurement,
    deleteMeasurement: deleteMeasurement,
    createBroadcast: createBroadcast,
    updateBroadcast: updateBroadcast,
    deleteBroadcast: deleteBroadcast,
    createExcercise: createExcercise,
    updateExcercise: updateExcercise,
    deleteExcercise: deleteExcercise,
    createWorkout: createWorkout,
    updateWorkout: updateWorkout,
    deleteWorkout: deleteWorkout,
    updateWorkoutOrder: updateWorkoutOrder,
    completeWorkout: completeWorkout,
    createMuscleRegion: createMuscleRegion,
    updateMuscleRegion: updateMuscleRegion,
    deleteMuscleRegion: deleteMuscleRegion,
    createExcerciseMetadata: createExcerciseMetadata,
    updateExcerciseMetadata: updateExcerciseMetadata,
  },

  //Root Query: Top level querying logic here
  Query: {
    user: userQueryResolvers,
    workouts: workoutsQueryResolver,
    getExcercise: getExcerciseQueryResolver,
    excercises: excercisesQueryResolver,
    broadcasts: broadCastsQueryResolver,
    notifications: notificationsQueryResolver,
    users: userQueryResolvers,
    workout_frequencies: workoutFrequencyQueryResolver,
    getExcercisePerformance: excercisePerformanceQueryResolver,
    getWorkoutsCompletedCount: getWorkoutsCompletedCountQueryResolver,
  },

  // Individual model querying here.
  User: {
    async measurements(parent: any, args: any, context: any, info: any) {
      const prisma = context.dataSources.prisma;
      return await prisma.measurement.findMany({
        where: {
          user_id: parent.user_id,
        },
        include: {
          muscle_region: true,
        },
      });
    },
    async workouts(parent: any, args: any, context: any, info: any) {
      const prisma = context.dataSources.prisma;
      return await prisma.workout.findMany({
        where: {
          user_id: parent.user_id,
        },
      });
    },
    async notifications(parent: any, args: any, context: any, info: any) {
      const prisma = context.dataSources.prisma;
      return await prisma.notification.findMany({
        where: {
          user_id: parent.user_id,
        },
      });
    },
    async broadcasts(parent: any, args: any, context: any, info: any) {
      const prisma = context.dataSources.prisma;
      return await prisma.broadCast.findMany({
        where: {
          users: {
            some: {
              user_id: parent.user_id,
            },
          },
        },
      });
    },
  },
  // workout query
  Workout: {
    async workout_group(parent: any, args: any, context: any, info: any) {
      const prisma = context.dataSources.prisma;
      return await prisma.workoutGroup.findUnique({
        where: { workout_group_id: parent.workout_group_id },
      });
    },

    async excercise_sets(parent: any, args: any, context: any, info: any) {
      const prisma = context.dataSources.prisma;
      return await prisma.ExcerciseSet.findMany({
        where: { workout_id: parent.workout_id },
        include: {
          excercise: true,
        },
      });
    },
  },
  ExcerciseSet: {
    async excercise(parent: any, args: any, context: any, info: any) {
      const prisma = context.dataSources.prisma;
      return await prisma.Excercise.findUnique({
        where: { excercise_id: parent.excercise_id },
      });
    },
  },

  Excercise: {
    async target_regions(parent: any, args: any, context: any, info: any) {
      const prisma = context.dataSources.prisma;
      return await prisma.muscleRegion.findMany({
        where: {
          target_muscles: {
            some: { excercise_id: parent.excercise_id },
          },
        },
      });
    },
    async stabilizer_muscles(parent: any, args: any, context: any, info: any) {
      const prisma = context.dataSources.prisma;
      return await prisma.muscleRegion.findMany({
        where: {
          stabilizer_muscles: {
            some: { excercise_id: parent.excercise_id },
          },
        },
      });
    },
    async synergist_muscles(parent: any, args: any, context: any, info: any) {
      const prisma = context.dataSources.prisma;
      return await prisma.muscleRegion.findMany({
        where: {
          synergist_muscles: {
            some: { excercise_id: parent.excercise_id },
          },
        },
      });
    },
    async dynamic_stabilizer_muscles(
      parent: any,
      args: any,
      context: any,
      info: any
    ) {
      const prisma = context.dataSources.prisma;
      return await prisma.muscleRegion.findMany({
        where: {
          dynamic_stabilizer_muscles: {
            some: { excercise_id: parent.excercise_id },
          },
        },
      });
    },
    async excerciseMetadata(parent: any, args: any, context: any, info: any) {
      const prisma = context.dataSources.prisma;
      return await prisma.excerciseMetadata.findUnique({
        where: {
          user_id_excercise_id: {
            excercise_id: parent.excercise_id,
            user_id: context.user.user_id,
          },
        },
      });
    },
  },
  BroadCast: {
    async users(parent: any, args: any, context: any, info: any) {
      const prisma = context.dataSources.prisma;
      return await prisma.user.findMany({
        where: {
          broadcasts: {
            some: { broad_cast_id: parent.broad_cast_id },
          },
        },
      });
    },
  },
};
