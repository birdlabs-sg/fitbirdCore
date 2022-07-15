"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.typeDefs = void 0;
const { gql } = require("apollo-server");
// Imports for object types
const broadCast_1 = require("./objectDef/broadCast");
const enum_1 = require("./objectDef/enum");
const excercise_1 = require("./objectDef/excercise");
const ExcerciseSet_1 = require("./objectDef/ExcerciseSet");
const measurement_1 = require("./objectDef/measurement");
const notification_1 = require("./objectDef/notification");
const muscleRegion_1 = require("./objectDef/muscleRegion");
const user_1 = require("./objectDef/user");
const workout_1 = require("./objectDef/workout");
// Imports for mutations
const mutateSignup_1 = require("./mutationDef/mutateSignup");
const mutateGenerateIdToken_1 = require("./mutationDef/mutateGenerateIdToken");
const mutateBroadcast_1 = require("./mutationDef/mutateBroadcast");
const mutateExcercise_1 = require("./mutationDef/mutateExcercise");
const mutateMuscleRegion_1 = require("./mutationDef/mutateMuscleRegion");
const mutateMeasurement_1 = require("./mutationDef/mutateMeasurement");
const mutateWorkout_1 = require("./mutationDef/mutateWorkout");
const mutateUser_1 = require("./mutationDef/mutateUser");
const exerciseMetadata_1 = require("./objectDef/exerciseMetadata");
const mutateExcerciseMetaData_1 = require("./mutationDef/mutateExcerciseMetaData");
const workoutFrequency_1 = require("./objectDef/workoutFrequency");
const excercisePerformance_1 = require("./objectDef/excercisePerformance");
const workoutGroup_1 = require("./objectDef/workoutGroup");
const queryTypeDef = gql `
  "This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request."
  type Query {
    user: User
    workouts(filter: WorkoutFilter!): [Workout]
    excercises: [Excercise]
    getExcercise(excercise_id: ID!): Excercise
    broadcasts: [BroadCast]
    notifications: [Notification]
    workout_frequencies: [WorkoutFrequency]
    getExcercisePerformance(excercise_id: ID!, span: Int): ExcercisePerformance
    "This query is only available to administrators."
    users: [User]
  }
`;
const mutationResponse = gql `
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
    mutateSignup_1.mutateSignup,
    mutateGenerateIdToken_1.mutatateGenerateIdToken,
    mutateBroadcast_1.mutateBroadCast,
    mutateExcercise_1.mutateExcercise,
    mutateMeasurement_1.mutateMeasurement,
    mutateMuscleRegion_1.mutateMuscleRegion,
    mutateWorkout_1.mutateWorkout,
    mutateUser_1.mutateUser,
    mutateExcerciseMetaData_1.mutateExcerciseMetadata,
];
const objectTypeDefs = [
    queryTypeDef,
    user_1.User,
    enum_1.Enum,
    measurement_1.Measurement,
    broadCast_1.BroadCast,
    excercise_1.Excercise,
    ExcerciseSet_1.ExcerciseSet,
    muscleRegion_1.MuscleRegion,
    notification_1.Notification,
    workout_1.Workout,
    exerciseMetadata_1.ExcerciseMetadata,
    workoutFrequency_1.WorkoutFrequency,
    excercisePerformance_1.ExcercisePerformance,
    workoutGroup_1.WorkoutGroup,
];
exports.typeDefs = baseTypeDefs.concat.apply(objectTypeDefs, mutationTypeDefs);
//# sourceMappingURL=rootTypeDefs.js.map