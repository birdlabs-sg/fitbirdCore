const { gql } = require("apollo-server");
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
import { BaseUsers } from "./objectDef/baseUsers";

// Imports for mutations
import { mutateSignup } from "./mutationDef/mutateSignup";
import { mutatateGenerateIdToken } from "./mutationDef/mutateGenerateIdToken";
import { mutateMuscleRegion } from "./mutationDef/mutateMuscleRegion";
import { mutateMeasurement } from "./mutationDef/mutateMeasurement";
import { mutateWorkout } from "./mutationDef/mutateWorkout";
import { mutateUser } from "./mutationDef/mutateUser";
import { ExcerciseMetadata } from "./objectDef/exerciseMetadata";
import { mutateExcerciseMetadata } from "./mutationDef/mutateExcerciseMetaData";
import { WorkoutFrequency } from "./objectDef/workoutFrequency";
import { ExcercisePerformance } from "./objectDef/excercisePerformance";
import { mutateGenerateWorkouts } from "./mutationDef/mutateGenerateWorkouts";
import { mutateNotification } from "./mutationDef/mutateNotification";


const queryTypeDef = gql`
  scalar Date
  "This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request."
  type Query {
    program:[Program]
    baseUsers:[BaseUsers]
    user: User
    workouts(filter: WorkoutFilter!, type: WorkoutType): [Workout]
    # TODO: Implement these to fit the description on linear
    getWorkout(workout_id: ID!): Workout
    excercises: [Excercise]
    excludedExcercises: [Excercise]
    getExcercise(excercise_name: ID!): Excercise
    notifications: [Notification]
    workout_frequencies: [WorkoutFrequency]
    getExcercisePerformance(
      excercise_name: ID!
      span: Int
    ): ExcercisePerformance
    getExcerciseMetadatas(excercise_names_list: [ID]!): [ExcerciseMetadata]
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
];

const objectTypeDefs = [
  BaseUsers,
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
  // Coach,
  // Program,
  // Review,
];

export const typeDefs = baseTypeDefs.concat.apply(
  objectTypeDefs,
  mutationTypeDefs
);
