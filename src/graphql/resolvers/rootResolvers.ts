import { excercisesQueryResolver } from "./exercise/queryExcercisesResolver";
import { notificationsQueryResolver } from "./notification/queryNotificationsResolver";
import { userQueryResolver } from "./user/queryUserResolver";
import { updateExerciseMetadataResolver } from "./exercise_metadata/updateExerciseMetadataResolver";
import { workoutFrequencyQueryResolver } from "./analytics/queryWorkoutFrequenciesResolver";
import { getExcerciseQueryResolver } from "./exercise/queryExcerciseResolver";
import { excercisePerformanceQueryResolver } from "./analytics/queryExcercisePerformanceResolver";
import { getExcerciseMetadatasQueryResolver } from "./exercise_metadata/queryExcerciseMetadatasResolver";
import { generateWorkoutReminderResolver } from "./notification/generateWorkoutReminderResolver";
import { generateNotificationResolver } from "./notification/generateNotificationResolver";
import { Resolvers } from "../../types/graphql";
import { usersQueryResolver } from "./user/queryUsersResolver";
import { GraphQLScalarType } from "graphql";
import {
  analyticsWorkoutAverageRPEResolver,
  analyticsExerciseOneRepMaxResolver,
  analyticsExerciseTotalVolumeResolver,
} from "./analytics/queryAnalyticsResolver";
import { updateBaseUserResolver } from "./user/updateBaseUserResolver";
import { getContentBlocksResolver } from "./content_block/queryContentBlocksResolver";

import { deleteProgramPreset } from "./preset/deleteProgramPresetResolver";
import { createProgramResolver } from "./program/createProgramResolver";
import { createMeasurementResolver } from "./measurement/createMeasurementResolver";
import { updateMeasurementResolver } from "./measurement/updateMeasurementResolver";
import { deleteMeasurementResolver } from "./measurement/deleteMeasurementResolver";
import { createMuscleRegionResolver } from "./muscle_region/createMuscleRegionResolver";
import { updateMuscleRegionResolver } from "./muscle_region/updateMuscleRegionResolver";
import { deleteMuscleRegionResolver } from "./muscle_region/deleteMuscleRegionResolver";
import { createProgramPresetResolver } from "./preset/createProgramPresetResolver";

import { presetQueryResolver } from "./preset/queryPresetResolver";
import { presetsQueryResolver } from "./preset/queryPresetsResolver";
import { generateFirebaseIdTokenResolver } from "./firebase/generateFirebaseIdTokenResolver";
import { privateMessagesQueryResolver } from "./firebase/queryPrivateMessagesResolver";
import { generateProgramResolver } from "./program/generateProgramResolver";
import { refreshProgramResolver } from "./program/refreshProgramResolver";
import { baseUserQueryResolver } from "./user/queryBaseUser";
import { signupResolver } from "./user/signupResolver";
import { createWorkoutResolver } from "./workout/createWorkoutResolver";
import { updateWorkoutResolver } from "./workout/updateWorkoutResolver";
import { deleteWorkoutResolver } from "./workout/deleteWorkoutResolver";
import { completeWorkoutResolver } from "./workout/completeWorkoutResolver";
import { createPrivateMessageResolver } from "./messages/createPrivateMessageResolver";
import { deletePrivateMessageResolver } from "./messages/deletePrivateMessageResolver";
import { queryWorkoutResolver } from "./workout/queryWorkoutResolver";
import { queryWorkoutsResolver } from "./workout/queryWorkoutsResolver";
import { updateUser } from "./user/updateUserResolver";
import { createCoachClientRelationshipResolver } from "./client_coach_relationship/createClientCoachRelationshipResolver";
import { updateCoachClientRelationshipResolver } from "./client_coach_relationship/updateClientCoachRelationshipResolver";
import { deleteCoachClientRelationshipResolver } from "./client_coach_relationship/deleteClientCoachRelationshipResolver";
import { getCoachClientRelationshipResolver } from "./client_coach_relationship/getClientCoachRelationshipResolver";
import { getCoachClientRelationshipsResolver } from "./client_coach_relationship/getClientCoachRelationshipsResolver";
import { queryProgramResolver } from "./program/queryProgramResolver";
import { queryProgramsResolver } from "./program/queryProgramsResolver";
import { updateProgramResolver } from "./program/updateProgramResolver";
import { deleteprogramResolver } from "./program/deleteProgramResolver";
import { getFirstDateOfCurrentWeek, getLastDateOfCurrentWeek } from "./utils";
import { queryPreviousWorkoutResolver } from "./workout/queryPreviousWorkoutResolver";

const dateScalar = new GraphQLScalarType({
  name: "Date",
  description: "Date custom scalar type",
  parseValue(inputValue: unknown) {
    // value from client as json
    return new Date(inputValue as string);
  },
});

export const resolvers: Resolvers = {
  Date: dateScalar,
  Mutation: {
    signup: signupResolver,
    generateFirebaseIdToken: generateFirebaseIdTokenResolver,
    generateWorkoutReminder: generateWorkoutReminderResolver,
    generateNotification: generateNotificationResolver,
    updateUser: updateUser,
    updateBaseUser: updateBaseUserResolver,
    createMeasurement: createMeasurementResolver,
    updateMeasurement: updateMeasurementResolver,
    deleteMeasurement: deleteMeasurementResolver,
    createWorkout: createWorkoutResolver,
    updateWorkout: updateWorkoutResolver,
    deleteWorkout: deleteWorkoutResolver,
    completeWorkout: completeWorkoutResolver,
    createMuscleRegion: createMuscleRegionResolver,
    updateMuscleRegion: updateMuscleRegionResolver,
    deleteMuscleRegion: deleteMuscleRegionResolver,
    updateExcerciseMetadata: updateExerciseMetadataResolver,
    createPrivateMessage: createPrivateMessageResolver,
    deletePrivateMessage: deletePrivateMessageResolver,
    createProgramPreset: createProgramPresetResolver,
    deleteProgramPreset: deleteProgramPreset,
    createProgram: createProgramResolver,
    updateProgram: updateProgramResolver,
    deleteProgram: deleteprogramResolver,
    generateProgram: generateProgramResolver,
    refreshProgram: refreshProgramResolver,
    createCoachClientRelationship: createCoachClientRelationshipResolver,
    updateCoachClientRelationship: updateCoachClientRelationshipResolver,
    deleteCoachClientRelationship: deleteCoachClientRelationshipResolver,
  },

  //Root Query: Top level querying logic here
  Query: {
    getContentBlocks: getContentBlocksResolver,
    programs: queryProgramsResolver,
    program: queryProgramResolver,
    preset: presetQueryResolver,
    presets: presetsQueryResolver,
    baseUser: baseUserQueryResolver,
    user: userQueryResolver,
    users: usersQueryResolver,
    workouts: queryWorkoutsResolver,
    workout: queryWorkoutResolver,
    previousWorkout: queryPreviousWorkoutResolver,
    getExcercise: getExcerciseQueryResolver,
    excercises: excercisesQueryResolver,
    notifications: notificationsQueryResolver,
    workout_frequencies: workoutFrequencyQueryResolver,
    getExcercisePerformance: excercisePerformanceQueryResolver,
    getExcerciseMetadatas: getExcerciseMetadatasQueryResolver,
    analyticsExerciseOneRepMax: analyticsExerciseOneRepMaxResolver,
    analyticsExerciseTotalVolume: analyticsExerciseTotalVolumeResolver,
    analyticsWorkoutAverageRPE: analyticsWorkoutAverageRPEResolver,
    getPrivateMessages: privateMessagesQueryResolver,
    getCoachClientRelationship: getCoachClientRelationshipResolver,
    getCoachClientRelationships: getCoachClientRelationshipsResolver,
  },
  // Chained resolvers - resolve nested fields (AKA non-scalar values)
  Workout: {
    async excercise_set_groups(parent, _, context) {
      const prisma = context.dataSources.prisma;
      return await prisma.excerciseSetGroup.findMany({
        where: { workout_id: parent.workout_id },
      });
    },
    async program(parent, _, context) {
      const prisma = context.dataSources.prisma;
      return await prisma.program.findFirst({
        where: { program_id: parent.programProgram_id },
      });
    },
  },

  User: {
    async selected_exercise_for_analytics(parent, _, context) {
      const prisma = context.dataSources.prisma;
      return await prisma.excercise.findMany({
        where: {
          User: {
            some: {
              user_id: parent.user_id,
            },
          },
        },
      });
    },
    async program(parent, _, context) {
      const prisma = context.dataSources.prisma;
      return await prisma.program.findMany({
        where: { user_id: parent.user_id },
        include: {
          workouts: true,
        },
      });
    },
    async base_user(parent, _, context) {
      const prisma = context.dataSources.prisma;
      return await prisma.baseUser.findFirstOrThrow({
        where: {
          User: {
            user_id: parent.user_id,
          },
        },
      });
    },
  },
  CoachClientRelationship: {
    async coach(parent, _, context) {
      const prisma = context.dataSources.prisma;
      return await prisma.coach.findUniqueOrThrow({
        where: { coach_id: parent.coach_id },
      });
    },

    async user(parent, _, context) {
      const prisma = context.dataSources.prisma;
      return await prisma.user.findUniqueOrThrow({
        where: { user_id: parent.user_id },
      });
    },
  },

  Program: {
    async coach(parent, _, context) {
      const prisma = context.dataSources.prisma;
      if (!parent.coach_id) {
        return null;
      }
      return await prisma.coach.findUniqueOrThrow({
        where: { coach_id: parent.coach_id },
      });
    },

    async user(parent, _, context) {
      const prisma = context.dataSources.prisma;
      return await prisma.user.findUniqueOrThrow({
        where: { user_id: parent.user_id },
      });
    },

    async workouts(parent, { workout_filter }, context) {
      const prisma = context.dataSources.prisma;
      const filteredWorkouts = await prisma.workout.findMany({
        where: {
          programProgram_id: parent.program_id,
          ...(workout_filter && {
            ...(workout_filter.upcoming != null && {
              date_scheduled: { lte: getLastDateOfCurrentWeek() },
              OR: [
                {
                  date_closed: { not: null },
                  date_scheduled: { gte: getFirstDateOfCurrentWeek() },
                },
                {
                  date_closed: null,
                },
              ],
            }),
            ...(workout_filter.program_id != null && {
              program_id: workout_filter.program_id,
            }),
            ...(workout_filter.workout_name != null && {
              workout_name: workout_filter.workout_name,
            }),
          }),
        },
      });

      return filteredWorkouts!;
    },
  },

  BaseUser: {
    async fcm_tokens(parent, _, context) {
      const prisma = context.dataSources.prisma;
      return await prisma.fCMToken.findMany({
        where: { baseUserBase_user_id: parent.base_user_id },
      });
    },
    async user(parent, _, context) {
      // can be null
      const prisma = context.dataSources.prisma;
      return await prisma.user.findUnique({
        where: { base_user_id: parent.base_user_id },
      });
    },

    async coach(parent, _, context) {
      // can be null
      const prisma = context.dataSources.prisma;
      return await prisma.coach.findUnique({
        where: { base_user_id: parent.base_user_id },
      });
    },
  },

  ExcerciseSetGroup: {
    async excercise(parent, _, context) {
      const prisma = context.dataSources.prisma;
      return await prisma.excercise.findUniqueOrThrow({
        where: {
          excercise_name: parent.excercise_name,
        },
      });
    },

    async excercise_metadata(parent, _, context) {
      // can be null
      const prisma = context.dataSources.prisma;
      return await prisma.excerciseMetadata.findUniqueOrThrow({
        where: {
          user_id_excercise_name: {
            user_id: context.base_user!.User!.user_id,
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
            user_id: context.base_user!.User!.user_id,
            excercise_name: parent.excercise_name,
          },
        },
      });
    },
  },
};
