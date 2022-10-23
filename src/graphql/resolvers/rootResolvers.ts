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
  regenerateWorkouts,
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
import { getExcerciseMetadatasQueryResolver } from "./query/queryExcerciseMetadatas";
import { workoutQueryResolver } from "./query/queryWorkout";
import {
  generateNotificationResolver,
  generateWorkoutReminderResolver,
} from "./mutation/generateNotificationResolver";
import { Resolvers } from "../../types/graphql";
import { usersQueryResolver } from "./query/queryUsers";
import { GraphQLScalarType } from "graphql";
import { baseUsersQueryResolver } from "./query/queryBaseUsers";
import { createProgram } from "./mutation/coachMutations/mutateCoachProgram";
import { coachUsersNotRegisteredQueryResolver } from "./query/coachQueries/queryCoachUsersNotRegistered";
import { coachWorkoutNameQueryResolver } from "./query/coachQueries/queryCoachWorkoutName";
import { coachUsersQueryResolver } from "./query/coachQueries/queryCoachUsers";
import { coachProgramQueryResolver } from "./query/coachQueries/queryCoachProgram";
import { coachProgramsQueryResolver } from "./query/coachQueries/queryCoachPrograms";
import { analyticsWorkoutAverageRPEResolver,analyticsExerciseOneRepMaxResolver,analyticsExerciseTotalVolumeResolver } from "./query/queryAnalytics";
import { updateBaseUserResolver } from "./mutation/mutateBaseUser";


const _ = require("lodash");
const dateScalar = new GraphQLScalarType({
  name: "Date",
  description: "Date custom scalar type",
  serialize(value: Date) {
    return value.toISOString(); // Convert outgoing Date to integer for JSON
  },
  parseValue(value: string) {
    return Date.parse(value); // Convert incoming integer to Date
  },
});

export const resolvers: Resolvers = {
  Date: dateScalar,
  //Mutations for create, update and delete operations
  Mutation: {
    signup: mutateSignup,
    generateFirebaseIdToken: generateFirebaseIdTokenResolver,
    generateWorkoutReminder: generateWorkoutReminderResolver,
    generateNotification: generateNotificationResolver,
    updateUser: updateUser,
    updateBaseUser: updateBaseUserResolver,
    createProgram: createProgram,
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
    regenerateWorkouts: regenerateWorkouts,
  },

  //Root Query: Top level querying logic here
  Query: {
    baseUsers: baseUsersQueryResolver,
    coachUsers: coachUsersQueryResolver,
    coachUsersNotRegistered: coachUsersNotRegisteredQueryResolver,
    coachProgram: coachProgramQueryResolver,
    coachPrograms: coachProgramsQueryResolver,
    coachWorkoutName:coachWorkoutNameQueryResolver,
    user: userQueryResolvers,
    workouts: workoutsQueryResolver,
    getWorkout: workoutQueryResolver,
    getExcercise: getExcerciseQueryResolver,
    excercises: excercisesQueryResolver,
    notifications: notificationsQueryResolver,
    users: usersQueryResolver,
    workout_frequencies: workoutFrequencyQueryResolver,
    getExcercisePerformance: excercisePerformanceQueryResolver,
    getExcerciseMetadatas: getExcerciseMetadatasQueryResolver,
    analyticsExerciseOneRepMax: analyticsExerciseOneRepMaxResolver,
    analyticsExerciseTotalVolume: analyticsExerciseTotalVolumeResolver,
    analyticsWorkoutAverageRPE: analyticsWorkoutAverageRPEResolver,
  },

  // workout query
  Workout: {
    async excercise_set_groups(parent, _, context) {
      const prisma = context.dataSources.prisma;
      return await prisma.excerciseSetGroup.findMany({
        where: { workout_id: parent.workout_id },
      });
    },
  },

  BaseUser: {
    async fcm_tokens(parent, _, context) {
      const prisma = context.dataSources.prisma;
      return await prisma.fCMToken.findMany({
        where: { baseUserBase_user_id: parent.base_user_id },
      });
    },
  },

  ExcerciseSetGroup: {
    async excercise(parent, _, context) {
      const prisma = context.dataSources.prisma;
      return await prisma.excercise.findUnique({
        where: {
          excercise_name: parent.excercise_name,
        },
      });
    },

    async excercise_metadata(parent, _, context) {
      const prisma = context.dataSources.prisma;
      return await prisma.excerciseMetadata.findUnique({
        where: {
          user_id_excercise_name: {
            user_id: context.user.user_id,
            excercise_name: parent.excercise_name,
          },
        },
      });
    },

    async excercise_sets(parent, _, context) {
      const prisma = context.dataSources.prisma;
      return await prisma.excerciseSet.findMany({
        where: {
          excercise_set_group_id: parent.excercise_set_group_id,
        },
      });
    },
  },

  Excercise: {
    async target_regions(parent, _, context) {
      const prisma = context.dataSources.prisma;
      return await prisma.muscleRegion.findMany({
        where: {
          target_muscles: {
            some: { excercise_name: parent.excercise_name },
          },
        },
      });
    },
    async stabilizer_muscles(parent, _, context) {
      const prisma = context.dataSources.prisma;
      return await prisma.muscleRegion.findMany({
        where: {
          stabilizer_muscles: {
            some: { excercise_name: parent.excercise_name },
          },
        },
      });
    },
    async synergist_muscles(parent, _, context) {
      const prisma = context.dataSources.prisma;
      return await prisma.muscleRegion.findMany({
        where: {
          synergist_muscles: {
            some: { excercise_name: parent.excercise_name },
          },
        },
      });
    },
    async dynamic_stabilizer_muscles(parent, _, context) {
      const prisma = context.dataSources.prisma;
      return await prisma.muscleRegion.findMany({
        where: {
          dynamic_stabilizer_muscles: {
            some: { excercise_name: parent.excercise_name },
          },
        },
      });
    },
    async excercise_metadata(parent, _, context) {
      const prisma = context.dataSources.prisma;
      return await prisma.excerciseMetadata.findUnique({
        where: {
          user_id_excercise_name: {
            user_id: context.user.user_id,
            excercise_name: parent.excercise_name,
          },
        },
      });
    },
  },
};
