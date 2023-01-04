import gql from "graphql-tag";
// Imports for object types
import { Enum } from "./enum";
import { Excercise } from "./exercise/excercise";
import { ExcerciseSet } from "./workout/excerciseSet";
import { Measurement } from "./measurement/measurement";
import { Notification } from "./notification/notification";
import { MuscleRegion } from "./muscle_region/muscleRegion";
import { User } from "./user/user";
import { Workout } from "./workout/workout";
import { BroadCast } from "./broadcast/broadCast";
import { Coach } from "./user/coach";
import { Program } from "./program/program";
import { Review } from "./user/review";
import { BaseUser } from "./user/baseUser";
import { Analytics } from "./analytics/analytics";
// Imports for mutations
import { mutateSignup } from "./user/mutateSignup";
import { mutatateGenerateIdToken } from "./firebase/mutateGenerateIdToken";
import { mutateMuscleRegion } from "./muscle_region/mutateMuscleRegion";
import { mutateMeasurement } from "./measurement/mutateMeasurement";
import { mutateWorkout } from "./workout/mutateWorkout";
import { mutateUser } from "./user/mutateUser";
import { mutateBaseUser } from "./user/mutateBaseUser";
import { ExcerciseMetadata } from "./exercise_metadata/exerciseMetadata";
import { mutateExcerciseMetadata } from "./exercise_metadata/mutateExcerciseMetaData";
import { WorkoutFrequency } from "./analytics/workoutFrequency";
import { ExcercisePerformance } from "./analytics/excercisePerformance";
import { mutateGenerateWorkouts } from "./program/mutateGenerateProgram";
import { mutateNotification } from "./notification/mutateNotification";
import { mutateProgram } from "./program/mutateProgram";
import { ContentBlock } from "./content_block/contentBlock";
import { privateMessage } from "./firebase/privateMessage";
import { mutatePrivateMessage } from "./firebase/mutatePrivateMessage";
import { mutatePreset } from "./preset/mutatePresets";
import { programPreset } from "./preset/programPreset";
import { PresetExcerciseSet } from "./preset/presetExcerciseSet";
import { PresetWorkout } from "./preset/presetWorkout";
import { mutateCoachClientRelationship } from "./coach_client_relationship/mutateCoachClientRelationship";
import { CoachClientRelationship } from "./coach_client_relationship/coachClientRelationship";

const queryTypeDef = gql`
  scalar Date
  "This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request."
  type Query {
    programs(user_id: ID!, coach_id: ID): [Program!]!
    program(user_id: ID!, coach_id: ID, program_id: ID!): Program!
    preset(programPreset_id: ID!): programPreset!
    presets: [programPreset!]!
    baseUser: BaseUser!
    user: User!
    workouts(filter: WorkoutQueryFilter!): [Workout!]!
    workout(workout_id: ID!, user_id: ID!, coach_id: ID): Workout!
    excercises: [Excercise!]!
    excludedExcercises: [Excercise!]!
    getExcercise(excercise_name: ID!): Excercise
    notifications: [Notification!]!
    analyticsExerciseOneRepMax(
      excercise_names_list: [ID!]!
      user_id: ID
    ): [ExerciseOneRepMaxDataPoint!]!
    analyticsExerciseTotalVolume(
      excercise_names_list: [ID!]!
      user_id: ID
    ): [ExerciseTotalVolumeDataPoint!]!
    analyticsWorkoutAverageRPE: [WorkoutAverageRPEDataPoint!]!
    workout_frequencies: [WorkoutFrequency!]!
    getExcercisePerformance(
      excercise_name: ID!
      span: Int
      user_id: ID
    ): ExcercisePerformance!
    getExcerciseMetadatas(excercise_names_list: [ID!]!): [ExcerciseMetadata!]!
    getContentBlocks(content_block_type: ContentBlockType!): [ContentBlock!]!
    getPrivateMessages(pair_id: ID!): [PrivateMessage!]!
    users(coach_filters: UserQueryCoachFilter): [User!]!
    getCoachClientRelationship(
      user_id: ID!
      coach_id: ID!
    ): CoachClientRelationship!
    getCoachClientRelationships: [CoachClientRelationship!]!
  }

  input UserQueryCoachFilter {
    clients: Boolean
    active: Boolean
  }
  input WorkoutQueryFilter {
    completed: Boolean
    workout_name: String
    program_id: ID
    user_id: ID!
    coach_id: ID
  }
`;

const mutationResponse = gql`
  "Standard mutation response. Each mutation response will implement this."
  interface MutationResponse {
    code: String!
    success: Boolean!
    message: String!
  }
`;

const baseTypeDefs = [queryTypeDef, mutationResponse];

const mutationTypeDefs = [
  mutationResponse,
  mutateSignup,
  mutatateGenerateIdToken,
  mutateMeasurement,
  mutateMuscleRegion,
  mutateWorkout,
  mutateUser,
  mutateExcerciseMetadata,
  mutateGenerateWorkouts,
  mutateNotification,
  mutateProgram,
  mutateBaseUser,
  mutatePrivateMessage,
  mutatePreset,
  mutateGenerateWorkouts,
  mutateCoachClientRelationship,
];

const objectTypeDefs = [
  BaseUser,
  queryTypeDef,
  User,
  Enum,
  Measurement,
  BroadCast,
  Excercise,
  ExcerciseSet,
  MuscleRegion,
  Notification,
  Workout,
  ExcerciseMetadata,
  WorkoutFrequency,
  ExcercisePerformance,
  Coach,
  Program,
  Review,
  Analytics,
  ContentBlock,
  privateMessage,
  programPreset,
  PresetExcerciseSet,
  PresetWorkout,
  CoachClientRelationship,
];

export const typeDefs = baseTypeDefs.concat.apply(
  objectTypeDefs,
  mutationTypeDefs
);
