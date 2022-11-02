import gql from "graphql-tag";
// Imports for object types
import { Enum } from "./objectDef/enum";
import { Excercise } from "./objectDef/excercise";
import { ExcerciseSet } from "./objectDef/excerciseSet";
import { Measurement } from "./objectDef/measurement";
import { Notification } from "./objectDef/notification";
import { MuscleRegion } from "./objectDef/muscleRegion";
import { User } from "./objectDef/user";
import { Workout } from "./objectDef/workout";
import { BroadCast } from "./objectDef/broadCast";
import { Coach } from "./objectDef/coach";
import { Program } from "./objectDef/program";
import { Review } from "./objectDef/review";
import { BaseUser } from "./objectDef/baseUser";
import { Analytics } from "./objectDef/analytics";

// Imports for mutations
import { mutateSignup } from "./mutationDef/mutateSignup";
import { mutatateGenerateIdToken } from "./mutationDef/mutateGenerateIdToken";
import { mutateMuscleRegion } from "./mutationDef/mutateMuscleRegion";
import { mutateMeasurement } from "./mutationDef/mutateMeasurement";
import { mutateWorkout } from "./mutationDef/mutateWorkout";
import { mutateUser } from "./mutationDef/mutateUser";
import { mutateBaseUser } from "./mutationDef/mutateBaseUser";
import { ExcerciseMetadata } from "./objectDef/exerciseMetadata";
import { mutateExcerciseMetadata } from "./mutationDef/mutateExcerciseMetaData";
import { WorkoutFrequency } from "./objectDef/workoutFrequency";
import { ExcercisePerformance } from "./objectDef/excercisePerformance";
import { mutateGenerateWorkouts } from "./mutationDef/mutateGenerateWorkouts";
import { mutateNotification } from "./mutationDef/mutateNotification";
import { mutateProgram } from "./mutationDef/mutateProgram";

const queryTypeDef = gql`
  scalar Date
  "This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request."
  type Query {
    baseUsers: [BaseUser]
    coachUsers: [BaseUser]
    coachAllUsers: [BaseUser]
    coachActiveProgram(user_id:ID!): Program
    coachWorkoutName(
      workout_name: ID!
      user_id: ID!
      programProgram_id: ID!
    ): Workout
    user: User
    workouts(filter: WorkoutFilter!, type: WorkoutType, user_id: ID): [Workout]
    # TODO: Implement these to fit the description on linear
    getWorkout(workout_id: ID!): Workout
    excercises: [Excercise]
    excludedExcercises: [Excercise]
    getExcercise(excercise_name: ID!): Excercise
    notifications: [Notification]
    analyticsExerciseOneRepMax(
      excercise_names_list: [ID!]!
      user_id:ID
    ): [ExerciseOneRepMaxDataPoint]
    analyticsExerciseTotalVolume(
      excercise_names_list: [ID!]!
      user_id:ID
    ): [ExerciseTotalVolumeDataPoint]
    analyticsWorkoutAverageRPE: [WorkoutAverageRPEDataPoint]
    workout_frequencies: [WorkoutFrequency]
    getExcercisePerformance(
      excercise_name: ID!
      span: Int
      user_id:ID
    ): ExcercisePerformance
    getExcerciseMetadatas(excercise_names_list: [ID!]!): [ExcerciseMetadata]
    "This query is only available to administrators."
    users: [User]
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
];

export const typeDefs = baseTypeDefs.concat.apply(
  objectTypeDefs,
  mutationTypeDefs
);
