const { gql } = require('apollo-server');
// Imports for object types
import { BroadCast } from "./objectDef/broadCast";
import { Enum } from "./objectDef/enum";
import { Excercise } from "./objectDef/excercise";
import { ExcerciseSet } from "./objectDef/ExcerciseSet";
import { Measurement } from "./objectDef/measurement";
import { Notification } from "./objectDef/notification";
import { MuscleRegion } from "./objectDef/muscleRegion";
import { User } from "./objectDef/user";
import { Workout } from "./objectDef/workout";
// Imports for mutations
import { mutateSignup } from "./mutationDef/mutateSignup";
import { mutatateGenerateIdToken } from "./mutationDef/mutateGenerateIdToken";
import { mutateBroadCast } from "./mutationDef/mutateBroadcast";
import { mutateExcercise } from "./mutationDef/mutateExcercise";
import { mutateMuscleRegion } from "./mutationDef/mutateMuscleRegion";
import { mutateMeasurement } from "./mutationDef/mutateMeasurement";
import { mutateWorkout } from "./mutationDef/mutateWorkout";
import { mutateUser } from "./mutationDef/mutateUser";



const queryTypeDef = gql`
   "This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request."
    type Query {
        user: User
        workouts: [Workout]
        excercises: [Excercise]
        broadcasts: [BroadCast]
        notifications: [Notification]
        "This query is only available to administrators."
        users: [User]
    }
`;

const mutationResponse =  gql`
    "Standard mutation response. Each mutation response will implement this."
    interface MutationResponse {
        code: String!
        success: Boolean!
        message: String!
    }
`;

const baseTypeDefs = [queryTypeDef,mutationResponse]

const mutationTypeDefs = [mutationResponse,mutateSignup,mutatateGenerateIdToken,mutateBroadCast,
                          mutateExcercise,mutateMeasurement,
                          mutateMuscleRegion,mutateWorkout,mutateUser]

const objectTypeDefs = [queryTypeDef,User, Enum, Measurement, 
                        BroadCast, Excercise, ExcerciseSet, 
                        MuscleRegion,Notification, Workout]
        

export const typeDefs = baseTypeDefs.concat.apply(objectTypeDefs,mutationTypeDefs)