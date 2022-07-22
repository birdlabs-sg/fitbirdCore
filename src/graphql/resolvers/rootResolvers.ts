import { generateFirebaseIdTokenResolver } from "./mutation/generateFirebaseIdTokenResolver";
import { updateUser } from "./mutation/mutateUser";
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
  generateWorkouts,
  updateWorkout,
  updateWorkoutOrder,
} from "./mutation/mutateWorkout";
import { mutateSignup } from "./mutation/mutateSignup";
import { excercisesQueryResolver } from "./query/queryExcercises";
import { notificationsQueryResolver } from "./query/queryNotifications";
import { userQueryResolvers } from "./query/queryUser";
import { workoutsQueryResolver } from "./query/queryWorkouts";
import { updateExcerciseMetadata } from "./mutation/mutateExcerciseMetadata";
import { workoutFrequencyQueryResolver } from "./query/queryWorkoutFrequencies";
import { getExcerciseQueryResolver } from "./query/queryExcercise";
import { excercisePerformanceQueryResolver } from "./query/queryExcercisePerformance";
import { ArgumentNode } from "graphql";
import { getExcerciseMetadatasQueryResolver } from "./query/queryExcerciseMetadatas";

export const resolvers = {
  //Mutations for create, update and delete operations
  Mutation: {
    signup: mutateSignup,
    generateFirebaseIdToken: generateFirebaseIdTokenResolver,
    updateUser: updateUser,
    createMeasurement: createMeasurement,
    updateMeasurement: updateMeasurement,
    deleteMeasurement: deleteMeasurement,
    createWorkout: createWorkout,
    updateWorkout: updateWorkout,
    deleteWorkout: deleteWorkout,
    updateWorkoutOrder: updateWorkoutOrder,
    completeWorkout: completeWorkout,
    createMuscleRegion: createMuscleRegion,
    updateMuscleRegion: updateMuscleRegion,
    deleteMuscleRegion: deleteMuscleRegion,
    updateExcerciseMetadata: updateExcerciseMetadata,
    generateWorkouts: generateWorkouts,
  },

  //Root Query: Top level querying logic here
  Query: {
    user: userQueryResolvers,
    workouts: workoutsQueryResolver,
    getExcercise: getExcerciseQueryResolver,
    excercises: excercisesQueryResolver,
    notifications: notificationsQueryResolver,
    users: userQueryResolvers,
    workout_frequencies: workoutFrequencyQueryResolver,
    getExcercisePerformance: excercisePerformanceQueryResolver,
    getExcerciseMetadatas: getExcerciseMetadatasQueryResolver,
  },
  // workout query
  Workout: {
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

  Excercise: {
    async target_regions(parent: any, args: any, context: any, info: any) {
      const prisma = context.dataSources.prisma;
      return await prisma.muscleRegion.findMany({
        where: {
          target_muscles: {
            some: { excercise_name: parent.excercise_name },
          },
        },
      });
    },
    async stabilizer_muscles(parent: any, args: any, context: any, info: any) {
      const prisma = context.dataSources.prisma;
      return await prisma.muscleRegion.findMany({
        where: {
          stabilizer_muscles: {
            some: { excercise_name: parent.excercise_name },
          },
        },
      });
    },
    async synergist_muscles(parent: any, args: any, context: any, info: any) {
      const prisma = context.dataSources.prisma;
      return await prisma.muscleRegion.findMany({
        where: {
          synergist_muscles: {
            some: { excercise_name: parent.excercise_name },
          },
        },
      });
    },
    async dynamic_stabilizer_muscles(
      parent: any,
      args: ArgumentNode,
      context: any,
      info: any
    ) {
      const prisma = context.dataSources.prisma;
      return await prisma.muscleRegion.findMany({
        where: {
          dynamic_stabilizer_muscles: {
            some: { excercise_name: parent.excercise_name },
          },
        },
      });
    },
    async excerciseMetadata(parent: any, args: any, context: any, info: any) {
      const prisma = context.dataSources.prisma;
      return await prisma.excerciseMetadata.findUnique({
        where: {
          user_id_excercise_name: {
            excercise_name: parent.excercise_name,
            user_id: context.user.user_id,
          },
        },
      });
    },
  },
};
