import { GraphQLResolveInfo, GraphQLScalarType, GraphQLScalarTypeConfig } from 'graphql';
import { Token as TokenModels } from './tokenType';
import { BaseUser as BaseUserModels, Coach as CoachModels, Program as ProgramModels, User as UserModels, Workout as WorkoutModels, ExcerciseMetadata as ExcerciseMetadataModels, Measurement as MeasurementModels, ExcerciseSetGroup as ExcerciseSetGroupModels, MuscleRegion as MuscleRegionModels, Excercise as ExcerciseModels, ExcerciseSet as ExcerciseSetModels, BroadCast as BroadCastModels, Notification as NotificationModels } from '@prisma/client';
import { AppContext } from './contextType';
export type Maybe<T> = T | null;
export type InputMaybe<T> = undefined | T;
export type Exact<T extends { [key: string]: unknown }> = { [K in keyof T]: T[K] };
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]?: Maybe<T[SubKey]> };
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]: Maybe<T[SubKey]> };
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type RequireFields<T, K extends keyof T> = Omit<T, K> & { [P in K]-?: NonNullable<T[P]> };
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: string;
  String: string;
  Boolean: boolean;
  Int: number;
  Float: number;
  Date: any;
};

/** Represents a user. Contains meta-data specific to each user. */
export type BaseUser = {
  __typename?: 'BaseUser';
  User?: Maybe<User>;
  base_user_id: Scalars['ID'];
  coach?: Maybe<Coach>;
  displayName?: Maybe<Scalars['String']>;
  email?: Maybe<Scalars['String']>;
  fcm_tokens?: Maybe<Array<FcmToken>>;
};

/** Represents broadcast message to selected users. */
export type BroadCast = {
  __typename?: 'BroadCast';
  broad_cast_id: Scalars['ID'];
  broadcast_message?: Maybe<Scalars['String']>;
  scheduled_end?: Maybe<Scalars['String']>;
  scheduled_start?: Maybe<Scalars['String']>;
};

/** Represents broadcast message to selected users. */
export type Coach = {
  __typename?: 'Coach';
  Program: Array<Maybe<Program>>;
  Review: Array<Maybe<Review>>;
  coach_id: Scalars['ID'];
  displayName: Scalars['String'];
  email: Scalars['String'];
  firebase_uid: Scalars['String'];
};

export enum Equipment {
  Barbell = 'BARBELL',
  Bench = 'BENCH',
  Cable = 'CABLE',
  Dumbbell = 'DUMBBELL',
  Kettlebell = 'KETTLEBELL',
  Lever = 'LEVER',
  MedicineBall = 'MEDICINE_BALL',
  ParallelBars = 'PARALLEL_BARS',
  Preacher = 'PREACHER',
  PullUpBar = 'PULL_UP_BAR',
  Sled = 'SLED',
  Smith = 'SMITH',
  StabilityBall = 'STABILITY_BALL',
  Suspension = 'SUSPENSION',
  TrapBar = 'TRAP_BAR',
  TBar = 'T_BAR'
}

/** Represents a specific excercise. */
export type Excercise = {
  __typename?: 'Excercise';
  assisted?: Maybe<Scalars['Boolean']>;
  body_weight?: Maybe<Scalars['Boolean']>;
  dynamic_stabilizer_muscles?: Maybe<Array<MuscleRegion>>;
  equipment_required?: Maybe<Array<Equipment>>;
  excercise_force?: Maybe<Array<Scalars['String']>>;
  excercise_instructions?: Maybe<Scalars['String']>;
  excercise_mechanics?: Maybe<Array<Scalars['String']>>;
  excercise_metadata?: Maybe<ExcerciseMetadata>;
  excercise_name: Scalars['ID'];
  excercise_preparation?: Maybe<Scalars['String']>;
  excercise_tips?: Maybe<Scalars['String']>;
  excercise_utility?: Maybe<Array<Scalars['String']>>;
  stabilizer_muscles?: Maybe<Array<MuscleRegion>>;
  synergist_muscles?: Maybe<Array<MuscleRegion>>;
  target_regions?: Maybe<Array<MuscleRegion>>;
};

export type ExcerciseInput = {
  excercise_name: Scalars['String'];
};

/** Represents a logical component of a workout session. */
export type ExcerciseMetadata = {
  __typename?: 'ExcerciseMetadata';
  best_rep: Scalars['Int'];
  best_weight: Scalars['Float'];
  excercise_metadata_state: ExcerciseMetadataState;
  excercise_name: Scalars['String'];
  haveRequiredEquipment?: Maybe<Scalars['Boolean']>;
  last_excecuted?: Maybe<Scalars['Date']>;
  preferred?: Maybe<Scalars['Boolean']>;
  rest_time_lower_bound: Scalars['Int'];
  rest_time_upper_bound: Scalars['Int'];
  weight_unit: WeightUnit;
};

export enum ExcerciseMetadataState {
  DecreasedDifficulty = 'DECREASED_DIFFICULTY',
  IncreasedDifficulty = 'INCREASED_DIFFICULTY',
  Learning = 'LEARNING',
  Maintainence = 'MAINTAINENCE'
}

export type ExcercisePerformance = {
  __typename?: 'ExcercisePerformance';
  grouped_excercise_sets?: Maybe<Array<GroupedExcerciseSets>>;
};

/** Represents a logical component of a workout session. */
export type ExcerciseSet = {
  __typename?: 'ExcerciseSet';
  actual_reps?: Maybe<Scalars['Int']>;
  actual_weight?: Maybe<Scalars['Float']>;
  excercise_set_id: Scalars['ID'];
  rate_of_perceived_exertion?: Maybe<Scalars['Int']>;
  target_reps?: Maybe<Scalars['Int']>;
  target_weight?: Maybe<Scalars['Float']>;
  weight_unit?: Maybe<WeightUnit>;
};

export type ExcerciseSetGroup = {
  __typename?: 'ExcerciseSetGroup';
  excercise?: Maybe<Excercise>;
  excercise_metadata?: Maybe<ExcerciseMetadata>;
  excercise_name: Scalars['String'];
  excercise_set_group_id?: Maybe<Scalars['String']>;
  excercise_set_group_state?: Maybe<ExcerciseSetGroupState>;
  excercise_sets: Array<ExcerciseSet>;
  failure_reason?: Maybe<FailureReason>;
};

/** Used in overloading algorithm to determine what to do with that set. */
export enum ExcerciseSetGroupState {
  DeletedPermanantly = 'DELETED_PERMANANTLY',
  DeletedTemporarily = 'DELETED_TEMPORARILY',
  NormalOperation = 'NORMAL_OPERATION',
  ReplacementPermanantly = 'REPLACEMENT_PERMANANTLY',
  ReplacementTemporarily = 'REPLACEMENT_TEMPORARILY'
}

export type ExerciseOneRepMaxDataPoint = {
  __typename?: 'ExerciseOneRepMaxDataPoint';
  date_completed?: Maybe<Scalars['Date']>;
  estimated_one_rep_max_value?: Maybe<Scalars['Float']>;
  exercise_name?: Maybe<Scalars['String']>;
};

export type ExerciseTotalVolumeDataPoint = {
  __typename?: 'ExerciseTotalVolumeDataPoint';
  date_completed?: Maybe<Scalars['Date']>;
  exercise_name?: Maybe<Scalars['String']>;
  exercise_total_volume?: Maybe<Scalars['Float']>;
};

export type FcmToken = {
  __typename?: 'FCMToken';
  date_issued?: Maybe<Scalars['Date']>;
  token?: Maybe<Scalars['String']>;
};

export enum FailureReason {
  InsufficientRestTime = 'INSUFFICIENT_REST_TIME',
  InsufficientSleep = 'INSUFFICIENT_SLEEP',
  InsufficientTime = 'INSUFFICIENT_TIME',
  LowMood = 'LOW_MOOD',
  TooDifficult = 'TOO_DIFFICULT'
}

/** Gender type. */
export enum Gender {
  Female = 'FEMALE',
  Male = 'MALE',
  RatherNotSay = 'RATHER_NOT_SAY'
}

/** Response if a token generation event is successful */
export type GenerateIdTokenResponse = MutationResponse & {
  __typename?: 'GenerateIdTokenResponse';
  code: Scalars['String'];
  message: Scalars['String'];
  success: Scalars['Boolean'];
  token?: Maybe<Token>;
};

export enum Goal {
  Athleticism = 'ATHLETICISM',
  BodyRecomposition = 'BODY_RECOMPOSITION',
  KeepingFit = 'KEEPING_FIT',
  Others = 'OTHERS',
  Strength = 'STRENGTH'
}

export type GroupedExcerciseSets = {
  __typename?: 'GroupedExcerciseSets';
  date_completed?: Maybe<Scalars['Date']>;
  excercise_sets?: Maybe<Array<ExcerciseSet>>;
};

/** Units for length. */
export enum LengthUnit {
  Cm = 'CM',
  Ft = 'FT',
  Mm = 'MM',
  Mtr = 'MTR'
}

export enum LevelOfExperience {
  Advanced = 'ADVANCED',
  Beginner = 'BEGINNER',
  Expert = 'EXPERT',
  Mid = 'MID'
}

/** Represents a measurement of a body part taken at a certain date. */
export type Measurement = {
  __typename?: 'Measurement';
  length_units?: Maybe<LengthUnit>;
  measured_at?: Maybe<Scalars['Date']>;
  measurement_id: Scalars['ID'];
  measurement_value?: Maybe<Scalars['Float']>;
  muscle_region?: Maybe<MuscleRegion>;
  user_id?: Maybe<Scalars['Int']>;
};

/** Represents a specific body part in the human anatomy. */
export type MuscleRegion = {
  __typename?: 'MuscleRegion';
  muscle_region_description?: Maybe<Scalars['String']>;
  muscle_region_id: Scalars['ID'];
  muscle_region_name?: Maybe<Scalars['String']>;
  muscle_region_type?: Maybe<MuscleRegionType>;
};

export enum MuscleRegionType {
  Back = 'BACK',
  Calves = 'CALVES',
  Chest = 'CHEST',
  ForeArm = 'FORE_ARM',
  Hips = 'HIPS',
  Neck = 'NECK',
  Shoulder = 'SHOULDER',
  Thighs = 'THIGHS',
  UpperArm = 'UPPER_ARM',
  Waist = 'WAIST'
}

/** Response if a mutation event is successful */
export type MutateBaseUserResponse = MutationResponse & {
  __typename?: 'MutateBaseUserResponse';
  code: Scalars['String'];
  message: Scalars['String'];
  success: Scalars['Boolean'];
  user?: Maybe<BaseUser>;
};

/** Response if a mutation event is successful */
export type MutateUserResponse = MutationResponse & {
  __typename?: 'MutateUserResponse';
  code: Scalars['String'];
  message: Scalars['String'];
  success: Scalars['Boolean'];
  user?: Maybe<User>;
};

/** [PROTECTED] Mutation to update the requestor's user information */
export type Mutation = {
  __typename?: 'Mutation';
  /** [PROTECTED] Updates a workout object (Must belong to the requestor). Note: This will replace any existing excercise sets. */
  completeWorkout?: Maybe<MutateWorkoutsResponse>;
  createExcerciseMetadata?: Maybe<MutateExcerciseMetaDataResponse>;
  /** [PROTECTED] Creates a measurement object for the requestor. */
  createMeasurement?: Maybe<MutateMeasurementResponse>;
  /** [PROTECTED] Creates a muscle region object. */
  createMuscleRegion?: Maybe<MutateMuscleRegionResponse>;
  /** [PROTECTED] Creates a program object (ONLY COACH). */
  createProgram?: Maybe<MutateProgramResponse>;
  /** [PROTECTED] Creates a workout object for the requestor. */
  createWorkout?: Maybe<MutateWorkoutResponse>;
  /** [PROTECTED] Deletes a measurement object for the requestor (Must belong to the requestor). */
  deleteMeasurement?: Maybe<MutateMeasurementResponse>;
  /** [PROTECTED] Deletes a muscle region object. */
  deleteMuscleRegion?: Maybe<MutateMuscleRegionResponse>;
  /** [PROTECTED] Deletes a workout object (Must belong to the requestor). */
  deleteWorkout?: Maybe<MutateWorkoutsResponse>;
  generateFirebaseIdToken?: Maybe<GenerateIdTokenResponse>;
  generateNotification?: Maybe<NotificationResponse>;
  generateWorkoutReminder?: Maybe<NotificationResponse>;
  generateWorkouts?: Maybe<Array<Workout>>;
  regenerateWorkouts?: Maybe<Array<Workout>>;
  signup?: Maybe<SignupResponse>;
  updateBaseUser?: Maybe<MutateBaseUserResponse>;
  /** [PROTECTED] Updates a excerciseMetadata object. */
  updateExcerciseMetadata?: Maybe<MutateExcerciseMetaDataResponse>;
  /** [PROTECTED] Update a measurement object for the requestor (Must belong to the requestor). */
  updateMeasurement?: Maybe<MutateMeasurementResponse>;
  /** [PROTECTED] Updates a muscle region object. */
  updateMuscleRegion?: Maybe<MutateMuscleRegionResponse>;
  updateUser?: Maybe<MutateUserResponse>;
  /** [PROTECTED] Updates a workout object (Must belong to the requestor). Note: This will replace any existing excercise sets. */
  updateWorkout?: Maybe<MutateWorkoutResponse>;
  updateWorkoutOrder?: Maybe<MutateWorkoutsResponse>;
};


/** [PROTECTED] Mutation to update the requestor's user information */
export type MutationCompleteWorkoutArgs = {
  excercise_set_groups: Array<ExcerciseSetGroupInput>;
  workout_id: Scalars['ID'];
};


/** [PROTECTED] Mutation to update the requestor's user information */
export type MutationCreateExcerciseMetadataArgs = {
  excercise_name: Scalars['ID'];
  haveRequiredEquipment?: InputMaybe<Scalars['Boolean']>;
  preferred?: InputMaybe<Scalars['Boolean']>;
  rest_time_lower_bound: Scalars['Int'];
  rest_time_upper_bound: Scalars['Int'];
};


/** [PROTECTED] Mutation to update the requestor's user information */
export type MutationCreateMeasurementArgs = {
  length_units: LengthUnit;
  measured_at: Scalars['Date'];
  measurement_value: Scalars['Float'];
  muscle_region_id: Scalars['ID'];
};


/** [PROTECTED] Mutation to update the requestor's user information */
export type MutationCreateMuscleRegionArgs = {
  muscle_region_description: Scalars['String'];
  muscle_region_name: Scalars['String'];
  muscle_region_type: MuscleRegionType;
};


/** [PROTECTED] Mutation to update the requestor's user information */
export type MutationCreateProgramArgs = {
  user_id: Scalars['ID'];
  workoutsInput?: InputMaybe<Array<WorkoutInput>>;
};


/** [PROTECTED] Mutation to update the requestor's user information */
export type MutationCreateWorkoutArgs = {
  excercise_set_groups: Array<ExcerciseSetGroupInput>;
  life_span: Scalars['Int'];
  workout_name: Scalars['String'];
  workout_type: WorkoutType;
};


/** [PROTECTED] Mutation to update the requestor's user information */
export type MutationDeleteMeasurementArgs = {
  measurement_id: Scalars['ID'];
};


/** [PROTECTED] Mutation to update the requestor's user information */
export type MutationDeleteMuscleRegionArgs = {
  muscle_region_id: Scalars['ID'];
};


/** [PROTECTED] Mutation to update the requestor's user information */
export type MutationDeleteWorkoutArgs = {
  workout_id: Scalars['ID'];
};


/** [PROTECTED] Mutation to update the requestor's user information */
export type MutationGenerateFirebaseIdTokenArgs = {
  uid: Scalars['String'];
};


/** [PROTECTED] Mutation to update the requestor's user information */
export type MutationGenerateNotificationArgs = {
  body: Scalars['String'];
  title: Scalars['String'];
  token: Scalars['String'];
};


/** [PROTECTED] Mutation to update the requestor's user information */
export type MutationGenerateWorkoutsArgs = {
  no_of_workouts: Scalars['Int'];
};


/** [PROTECTED] Mutation to update the requestor's user information */
export type MutationSignupArgs = {
  displayName: Scalars['String'];
  email: Scalars['String'];
  is_user: Scalars['Boolean'];
  password: Scalars['String'];
  phoneNumber?: InputMaybe<Scalars['String']>;
};


/** [PROTECTED] Mutation to update the requestor's user information */
export type MutationUpdateBaseUserArgs = {
  displayName?: InputMaybe<Scalars['String']>;
  email?: InputMaybe<Scalars['String']>;
  fcm_tokens?: InputMaybe<Array<InputMaybe<Scalars['String']>>>;
};


/** [PROTECTED] Mutation to update the requestor's user information */
export type MutationUpdateExcerciseMetadataArgs = {
  excercise_name: Scalars['ID'];
  haveRequiredEquipment?: InputMaybe<Scalars['Boolean']>;
  preferred?: InputMaybe<Scalars['Boolean']>;
  rest_time_lower_bound?: InputMaybe<Scalars['Int']>;
  rest_time_upper_bound?: InputMaybe<Scalars['Int']>;
};


/** [PROTECTED] Mutation to update the requestor's user information */
export type MutationUpdateMeasurementArgs = {
  length_units?: InputMaybe<LengthUnit>;
  measured_at?: InputMaybe<Scalars['Date']>;
  measurement_id: Scalars['ID'];
  measurement_value?: InputMaybe<Scalars['Float']>;
  muscle_region_id?: InputMaybe<Scalars['Int']>;
};


/** [PROTECTED] Mutation to update the requestor's user information */
export type MutationUpdateMuscleRegionArgs = {
  muscle_region_description?: InputMaybe<Scalars['String']>;
  muscle_region_id: Scalars['ID'];
  muscle_region_name?: InputMaybe<Scalars['String']>;
};


/** [PROTECTED] Mutation to update the requestor's user information */
export type MutationUpdateUserArgs = {
  age?: InputMaybe<Scalars['Int']>;
  ai_managed_workouts_life_cycle?: InputMaybe<Scalars['Int']>;
  automatic_scheduling?: InputMaybe<Scalars['Boolean']>;
  body_weight_rep_lower_bound?: InputMaybe<Scalars['Int']>;
  body_weight_rep_upper_bound?: InputMaybe<Scalars['Int']>;
  compound_movement_rep_lower_bound?: InputMaybe<Scalars['Int']>;
  compound_movement_rep_upper_bound?: InputMaybe<Scalars['Int']>;
  dark_mode?: InputMaybe<Scalars['Boolean']>;
  equipment_accessible?: InputMaybe<Array<Equipment>>;
  gender?: InputMaybe<Gender>;
  goal?: InputMaybe<Goal>;
  height?: InputMaybe<Scalars['Float']>;
  height_unit?: InputMaybe<LengthUnit>;
  isolated_movement_rep_lower_bound?: InputMaybe<Scalars['Int']>;
  isolated_movement_rep_upper_bound?: InputMaybe<Scalars['Int']>;
  level_of_experience?: InputMaybe<LevelOfExperience>;
  prior_years_of_experience?: InputMaybe<Scalars['Float']>;
  selected_exercise_for_analytics?: InputMaybe<Array<ExcerciseInput>>;
  use_rpe?: InputMaybe<Scalars['Boolean']>;
  weight?: InputMaybe<Scalars['Float']>;
  weight_unit?: InputMaybe<WeightUnit>;
  workout_duration?: InputMaybe<Scalars['Int']>;
  workout_frequency?: InputMaybe<Scalars['Int']>;
  workout_type_enrollment?: InputMaybe<WorkoutType>;
};


/** [PROTECTED] Mutation to update the requestor's user information */
export type MutationUpdateWorkoutArgs = {
  date_scheduled?: InputMaybe<Scalars['Date']>;
  excercise_set_groups?: InputMaybe<Array<ExcerciseSetGroupInput>>;
  life_span?: InputMaybe<Scalars['Int']>;
  performance_rating?: InputMaybe<Scalars['Float']>;
  workout_id: Scalars['ID'];
  workout_name?: InputMaybe<Scalars['String']>;
  workout_state?: InputMaybe<WorkoutState>;
};


/** [PROTECTED] Mutation to update the requestor's user information */
export type MutationUpdateWorkoutOrderArgs = {
  newIndex: Scalars['Int'];
  oldIndex: Scalars['Int'];
  workout_type: WorkoutType;
};

/** Standard mutation response. Each mutation response will implement this. */
export type MutationResponse = {
  code: Scalars['String'];
  message: Scalars['String'];
  success: Scalars['Boolean'];
};

/** Represents notification message for a specific user. */
export type Notification = {
  __typename?: 'Notification';
  notification_id: Scalars['ID'];
  notification_message?: Maybe<Scalars['String']>;
  user_id?: Maybe<Scalars['Int']>;
};

/** Response if a signup event is successful */
export type NotificationResponse = MutationResponse & {
  __typename?: 'NotificationResponse';
  code: Scalars['String'];
  message: Scalars['String'];
  success: Scalars['Boolean'];
};

/** Represents programs for coaches. */
export type Program = {
  __typename?: 'Program';
  coach_id: Scalars['ID'];
  is_active?: Maybe<Scalars['Boolean']>;
  program_id: Scalars['ID'];
  user_id: Scalars['ID'];
  workouts?: Maybe<Array<Workout>>;
};

/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type Query = {
  __typename?: 'Query';
  analyticsExerciseOneRepMax?: Maybe<Array<Maybe<ExerciseOneRepMaxDataPoint>>>;
  analyticsExerciseTotalVolume?: Maybe<Array<Maybe<ExerciseTotalVolumeDataPoint>>>;
  analyticsWorkoutAverageRPE?: Maybe<Array<Maybe<WorkoutAverageRpeDataPoint>>>;
  baseUser?: Maybe<BaseUser>;
  baseUsers?: Maybe<Array<Maybe<BaseUser>>>;
  coachProgram?: Maybe<Program>;
  coachPrograms?: Maybe<Array<Maybe<Program>>>;
  coachUsers?: Maybe<Array<Maybe<BaseUser>>>;
  coachUsersNotRegistered?: Maybe<Array<Maybe<BaseUser>>>;
  coachWorkoutName?: Maybe<Workout>;
  excercises?: Maybe<Array<Maybe<Excercise>>>;
  excludedExcercises?: Maybe<Array<Maybe<Excercise>>>;
  getExcercise?: Maybe<Excercise>;
  getExcerciseMetadatas?: Maybe<Array<Maybe<ExcerciseMetadata>>>;
  getExcercisePerformance?: Maybe<ExcercisePerformance>;
  getWorkout?: Maybe<Workout>;
  notifications?: Maybe<Array<Maybe<Notification>>>;
  user?: Maybe<User>;
  /** This query is only available to administrators. */
  users?: Maybe<Array<Maybe<User>>>;
  workout_frequencies?: Maybe<Array<Maybe<WorkoutFrequency>>>;
  workouts?: Maybe<Array<Maybe<Workout>>>;
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryAnalyticsExerciseOneRepMaxArgs = {
  excercise_names_list: Array<InputMaybe<Scalars['ID']>>;
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryAnalyticsExerciseTotalVolumeArgs = {
  excercise_names_list: Array<InputMaybe<Scalars['ID']>>;
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryCoachProgramArgs = {
  program_id: Scalars['ID'];
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryCoachWorkoutNameArgs = {
  programProgram_id: Scalars['ID'];
  user_id: Scalars['ID'];
  workout_name: Scalars['ID'];
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryGetExcerciseArgs = {
  excercise_name: Scalars['ID'];
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryGetExcerciseMetadatasArgs = {
  excercise_names_list: Array<InputMaybe<Scalars['ID']>>;
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryGetExcercisePerformanceArgs = {
  excercise_name: Scalars['ID'];
  span?: InputMaybe<Scalars['Int']>;
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryGetWorkoutArgs = {
  workout_id: Scalars['ID'];
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryWorkoutsArgs = {
  filter: WorkoutFilter;
  type?: InputMaybe<WorkoutType>;
  user_id?: InputMaybe<Scalars['ID']>;
};

/** Represents broadcast message to selected users. */
export type Review = {
  __typename?: 'Review';
  content: Scalars['String'];
  rating: Scalars['String'];
  review_id: Scalars['ID'];
};

/** Response if a signup event is successful */
export type SignupResponse = MutationResponse & {
  __typename?: 'SignupResponse';
  code: Scalars['String'];
  message: Scalars['String'];
  success: Scalars['Boolean'];
};

/** Represents a firebase id Token */
export type Token = {
  __typename?: 'Token';
  expiresIn: Scalars['String'];
  idToken: Scalars['String'];
  isNewUser: Scalars['Boolean'];
  kind: Scalars['String'];
  refreshToken: Scalars['String'];
};

/** Represents a user. Contains meta-data specific to each user. */
export type User = {
  __typename?: 'User';
  age?: Maybe<Scalars['Int']>;
  ai_managed_workouts_life_cycle?: Maybe<Scalars['Int']>;
  automatic_scheduling?: Maybe<Scalars['Boolean']>;
  body_weight_rep_lower_bound?: Maybe<Scalars['Int']>;
  body_weight_rep_upper_bound?: Maybe<Scalars['Int']>;
  compound_movement_rep_lower_bound?: Maybe<Scalars['Int']>;
  compound_movement_rep_upper_bound?: Maybe<Scalars['Int']>;
  dark_mode?: Maybe<Scalars['Boolean']>;
  equipment_accessible?: Maybe<Array<Equipment>>;
  gender?: Maybe<Gender>;
  goal?: Maybe<Goal>;
  height?: Maybe<Scalars['Float']>;
  height_unit?: Maybe<LengthUnit>;
  isolated_movement_rep_lower_bound?: Maybe<Scalars['Int']>;
  isolated_movement_rep_upper_bound?: Maybe<Scalars['Int']>;
  level_of_experience?: Maybe<LevelOfExperience>;
  prior_years_of_experience?: Maybe<Scalars['Float']>;
  program?: Maybe<Array<Program>>;
  selected_exercise_for_analytics?: Maybe<Array<Excercise>>;
  use_rpe?: Maybe<Scalars['Boolean']>;
  user_id: Scalars['ID'];
  weight?: Maybe<Scalars['Float']>;
  weight_unit?: Maybe<WeightUnit>;
  workout_duration?: Maybe<Scalars['Int']>;
  workout_frequency?: Maybe<Scalars['Int']>;
  workout_type_enrollment?: Maybe<WorkoutType>;
};

/** Units for weight */
export enum WeightUnit {
  Kg = 'KG',
  Lb = 'LB'
}

/** Represents a user. Contains meta-data specific to each user. */
export type Workout = {
  __typename?: 'Workout';
  date_completed?: Maybe<Scalars['Date']>;
  date_scheduled?: Maybe<Scalars['Date']>;
  excercise_set_groups?: Maybe<Array<ExcerciseSetGroup>>;
  life_span?: Maybe<Scalars['Int']>;
  order_index?: Maybe<Scalars['Int']>;
  performance_rating?: Maybe<Scalars['Float']>;
  programProgram_id?: Maybe<Scalars['ID']>;
  user_id?: Maybe<Scalars['ID']>;
  workout_id: Scalars['ID'];
  workout_name?: Maybe<Scalars['String']>;
  workout_state?: Maybe<WorkoutState>;
  workout_type?: Maybe<WorkoutType>;
};

export type WorkoutAverageRpeDataPoint = {
  __typename?: 'WorkoutAverageRPEDataPoint';
  average_rpe_value?: Maybe<Scalars['Float']>;
  date_completed?: Maybe<Scalars['Date']>;
};

/** Units for weight */
export enum WorkoutFilter {
  Active = 'ACTIVE',
  Completed = 'COMPLETED',
  None = 'NONE'
}

/** Represents a user. Contains meta-data specific to each user. */
export type WorkoutFrequency = {
  __typename?: 'WorkoutFrequency';
  week_identifier?: Maybe<Scalars['String']>;
  workout_count: Scalars['Int'];
};

export enum WorkoutState {
  Completed = 'COMPLETED',
  Draft = 'DRAFT',
  InProgress = 'IN_PROGRESS',
  Unattempted = 'UNATTEMPTED'
}

export enum WorkoutType {
  AiManaged = 'AI_MANAGED',
  CoachManaged = 'COACH_MANAGED',
  SelfManaged = 'SELF_MANAGED'
}

export type ExcerciseMetaDataInput = {
  best_rep?: InputMaybe<Scalars['Int']>;
  best_weight?: InputMaybe<Scalars['Float']>;
  excercise_metadata_state?: InputMaybe<ExcerciseMetadataState>;
  excercise_name: Scalars['ID'];
  haveRequiredEquipment?: InputMaybe<Scalars['Boolean']>;
  last_excecuted?: InputMaybe<Scalars['Date']>;
  preferred?: InputMaybe<Scalars['Boolean']>;
  rest_time_lower_bound?: InputMaybe<Scalars['Int']>;
  rest_time_upper_bound?: InputMaybe<Scalars['Int']>;
  weight_unit?: InputMaybe<WeightUnit>;
};

export type ExcerciseSetGroupInput = {
  excercise_metadata: ExcerciseMetaDataInput;
  excercise_name: Scalars['String'];
  excercise_set_group_state: ExcerciseSetGroupState;
  excercise_sets: Array<ExcerciseSetInput>;
  failure_reason?: InputMaybe<FailureReason>;
};

export type ExcerciseSetInput = {
  actual_reps?: InputMaybe<Scalars['Int']>;
  actual_weight?: InputMaybe<Scalars['Float']>;
  rate_of_perceived_exertion?: InputMaybe<Scalars['Int']>;
  target_reps: Scalars['Int'];
  target_weight: Scalars['Float'];
  weight_unit: WeightUnit;
};

/** Response if mutating a excercise was successful */
export type MutateExcerciseMetaDataResponse = MutationResponse & {
  __typename?: 'mutateExcerciseMetaDataResponse';
  code: Scalars['String'];
  excercise_metadata?: Maybe<ExcerciseMetadata>;
  message: Scalars['String'];
  success: Scalars['Boolean'];
};

/** Response if a mutation of a measurement is successful */
export type MutateMeasurementResponse = MutationResponse & {
  __typename?: 'mutateMeasurementResponse';
  code: Scalars['String'];
  measurement?: Maybe<Measurement>;
  message: Scalars['String'];
  success: Scalars['Boolean'];
};

/** Response if mutating a muscle region was successful */
export type MutateMuscleRegionResponse = MutationResponse & {
  __typename?: 'mutateMuscleRegionResponse';
  code: Scalars['String'];
  message: Scalars['String'];
  muscle_region?: Maybe<MuscleRegion>;
  success: Scalars['Boolean'];
};

export type MutateProgramResponse = MutationResponse & {
  __typename?: 'mutateProgramResponse';
  code: Scalars['String'];
  message: Scalars['String'];
  program?: Maybe<Program>;
  success: Scalars['Boolean'];
};

/** Response when mutating a workout */
export type MutateWorkoutResponse = MutationResponse & {
  __typename?: 'mutateWorkoutResponse';
  code: Scalars['String'];
  message: Scalars['String'];
  success: Scalars['Boolean'];
  workout?: Maybe<Workout>;
};

/** Response when mutating multiple workouts */
export type MutateWorkoutsResponse = MutationResponse & {
  __typename?: 'mutateWorkoutsResponse';
  code: Scalars['String'];
  message: Scalars['String'];
  success: Scalars['Boolean'];
  workouts?: Maybe<Array<Workout>>;
};

export type WorkoutInput = {
  date_scheduled?: InputMaybe<Scalars['Date']>;
  excercise_set_groups?: InputMaybe<Array<ExcerciseSetGroupInput>>;
  life_span?: InputMaybe<Scalars['Int']>;
  order_index?: InputMaybe<Scalars['Int']>;
  user_id: Scalars['ID'];
  workout_name?: InputMaybe<Scalars['String']>;
  workout_state?: InputMaybe<WorkoutState>;
  workout_type: WorkoutType;
};



export type ResolverTypeWrapper<T> = Promise<T> | T;


export type ResolverWithResolve<TResult, TParent, TContext, TArgs> = {
  resolve: ResolverFn<TResult, TParent, TContext, TArgs>;
};
export type Resolver<TResult, TParent = {}, TContext = {}, TArgs = {}> = ResolverFn<TResult, TParent, TContext, TArgs> | ResolverWithResolve<TResult, TParent, TContext, TArgs>;

export type ResolverFn<TResult, TParent, TContext, TArgs> = (
  parent: TParent,
  args: TArgs,
  context: TContext,
  info: GraphQLResolveInfo
) => Promise<TResult> | TResult;

export type SubscriptionSubscribeFn<TResult, TParent, TContext, TArgs> = (
  parent: TParent,
  args: TArgs,
  context: TContext,
  info: GraphQLResolveInfo
) => AsyncIterable<TResult> | Promise<AsyncIterable<TResult>>;

export type SubscriptionResolveFn<TResult, TParent, TContext, TArgs> = (
  parent: TParent,
  args: TArgs,
  context: TContext,
  info: GraphQLResolveInfo
) => TResult | Promise<TResult>;

export interface SubscriptionSubscriberObject<TResult, TKey extends string, TParent, TContext, TArgs> {
  subscribe: SubscriptionSubscribeFn<{ [key in TKey]: TResult }, TParent, TContext, TArgs>;
  resolve?: SubscriptionResolveFn<TResult, { [key in TKey]: TResult }, TContext, TArgs>;
}

export interface SubscriptionResolverObject<TResult, TParent, TContext, TArgs> {
  subscribe: SubscriptionSubscribeFn<any, TParent, TContext, TArgs>;
  resolve: SubscriptionResolveFn<TResult, any, TContext, TArgs>;
}

export type SubscriptionObject<TResult, TKey extends string, TParent, TContext, TArgs> =
  | SubscriptionSubscriberObject<TResult, TKey, TParent, TContext, TArgs>
  | SubscriptionResolverObject<TResult, TParent, TContext, TArgs>;

export type SubscriptionResolver<TResult, TKey extends string, TParent = {}, TContext = {}, TArgs = {}> =
  | ((...args: any[]) => SubscriptionObject<TResult, TKey, TParent, TContext, TArgs>)
  | SubscriptionObject<TResult, TKey, TParent, TContext, TArgs>;

export type TypeResolveFn<TTypes, TParent = {}, TContext = {}> = (
  parent: TParent,
  context: TContext,
  info: GraphQLResolveInfo
) => Maybe<TTypes> | Promise<Maybe<TTypes>>;

export type IsTypeOfResolverFn<T = {}, TContext = {}> = (obj: T, context: TContext, info: GraphQLResolveInfo) => boolean | Promise<boolean>;

export type NextResolverFn<T> = () => Promise<T>;

export type DirectiveResolverFn<TResult = {}, TParent = {}, TContext = {}, TArgs = {}> = (
  next: NextResolverFn<TResult>,
  parent: TParent,
  args: TArgs,
  context: TContext,
  info: GraphQLResolveInfo
) => TResult | Promise<TResult>;

/** Mapping between all available schema types and the resolvers types */
export type ResolversTypes = {
  BaseUser: ResolverTypeWrapper<BaseUserModels>;
  Boolean: ResolverTypeWrapper<Scalars['Boolean']>;
  BroadCast: ResolverTypeWrapper<BroadCastModels>;
  Coach: ResolverTypeWrapper<CoachModels>;
  Date: ResolverTypeWrapper<Scalars['Date']>;
  Equipment: Equipment;
  Excercise: ResolverTypeWrapper<ExcerciseModels>;
  ExcerciseInput: ExcerciseInput;
  ExcerciseMetadata: ResolverTypeWrapper<ExcerciseMetadataModels>;
  ExcerciseMetadataState: ExcerciseMetadataState;
  ExcercisePerformance: ResolverTypeWrapper<Omit<ExcercisePerformance, 'grouped_excercise_sets'> & { grouped_excercise_sets?: Maybe<Array<ResolversTypes['GroupedExcerciseSets']>> }>;
  ExcerciseSet: ResolverTypeWrapper<ExcerciseSetModels>;
  ExcerciseSetGroup: ResolverTypeWrapper<ExcerciseSetGroupModels>;
  ExcerciseSetGroupState: ExcerciseSetGroupState;
  ExerciseOneRepMaxDataPoint: ResolverTypeWrapper<ExerciseOneRepMaxDataPoint>;
  ExerciseTotalVolumeDataPoint: ResolverTypeWrapper<ExerciseTotalVolumeDataPoint>;
  FCMToken: ResolverTypeWrapper<FcmToken>;
  FailureReason: FailureReason;
  Float: ResolverTypeWrapper<Scalars['Float']>;
  Gender: Gender;
  GenerateIdTokenResponse: ResolverTypeWrapper<Omit<GenerateIdTokenResponse, 'token'> & { token?: Maybe<ResolversTypes['Token']> }>;
  Goal: Goal;
  GroupedExcerciseSets: ResolverTypeWrapper<Omit<GroupedExcerciseSets, 'excercise_sets'> & { excercise_sets?: Maybe<Array<ResolversTypes['ExcerciseSet']>> }>;
  ID: ResolverTypeWrapper<Scalars['ID']>;
  Int: ResolverTypeWrapper<Scalars['Int']>;
  LengthUnit: LengthUnit;
  LevelOfExperience: LevelOfExperience;
  Measurement: ResolverTypeWrapper<MeasurementModels>;
  MuscleRegion: ResolverTypeWrapper<MuscleRegionModels>;
  MuscleRegionType: MuscleRegionType;
  MutateBaseUserResponse: ResolverTypeWrapper<Omit<MutateBaseUserResponse, 'user'> & { user?: Maybe<ResolversTypes['BaseUser']> }>;
  MutateUserResponse: ResolverTypeWrapper<Omit<MutateUserResponse, 'user'> & { user?: Maybe<ResolversTypes['User']> }>;
  Mutation: ResolverTypeWrapper<{}>;
  MutationResponse: ResolversTypes['GenerateIdTokenResponse'] | ResolversTypes['MutateBaseUserResponse'] | ResolversTypes['MutateUserResponse'] | ResolversTypes['NotificationResponse'] | ResolversTypes['SignupResponse'] | ResolversTypes['mutateExcerciseMetaDataResponse'] | ResolversTypes['mutateMeasurementResponse'] | ResolversTypes['mutateMuscleRegionResponse'] | ResolversTypes['mutateProgramResponse'] | ResolversTypes['mutateWorkoutResponse'] | ResolversTypes['mutateWorkoutsResponse'];
  Notification: ResolverTypeWrapper<NotificationModels>;
  NotificationResponse: ResolverTypeWrapper<NotificationResponse>;
  Program: ResolverTypeWrapper<ProgramModels>;
  Query: ResolverTypeWrapper<{}>;
  Review: ResolverTypeWrapper<Review>;
  SignupResponse: ResolverTypeWrapper<SignupResponse>;
  String: ResolverTypeWrapper<Scalars['String']>;
  Token: ResolverTypeWrapper<TokenModels>;
  User: ResolverTypeWrapper<UserModels>;
  WeightUnit: WeightUnit;
  Workout: ResolverTypeWrapper<WorkoutModels>;
  WorkoutAverageRPEDataPoint: ResolverTypeWrapper<WorkoutAverageRpeDataPoint>;
  WorkoutFilter: WorkoutFilter;
  WorkoutFrequency: ResolverTypeWrapper<WorkoutFrequency>;
  WorkoutState: WorkoutState;
  WorkoutType: WorkoutType;
  excerciseMetaDataInput: ExcerciseMetaDataInput;
  excerciseSetGroupInput: ExcerciseSetGroupInput;
  excerciseSetInput: ExcerciseSetInput;
  mutateExcerciseMetaDataResponse: ResolverTypeWrapper<Omit<MutateExcerciseMetaDataResponse, 'excercise_metadata'> & { excercise_metadata?: Maybe<ResolversTypes['ExcerciseMetadata']> }>;
  mutateMeasurementResponse: ResolverTypeWrapper<Omit<MutateMeasurementResponse, 'measurement'> & { measurement?: Maybe<ResolversTypes['Measurement']> }>;
  mutateMuscleRegionResponse: ResolverTypeWrapper<Omit<MutateMuscleRegionResponse, 'muscle_region'> & { muscle_region?: Maybe<ResolversTypes['MuscleRegion']> }>;
  mutateProgramResponse: ResolverTypeWrapper<Omit<MutateProgramResponse, 'program'> & { program?: Maybe<ResolversTypes['Program']> }>;
  mutateWorkoutResponse: ResolverTypeWrapper<Omit<MutateWorkoutResponse, 'workout'> & { workout?: Maybe<ResolversTypes['Workout']> }>;
  mutateWorkoutsResponse: ResolverTypeWrapper<Omit<MutateWorkoutsResponse, 'workouts'> & { workouts?: Maybe<Array<ResolversTypes['Workout']>> }>;
  workoutInput: WorkoutInput;
};

/** Mapping between all available schema types and the resolvers parents */
export type ResolversParentTypes = {
  BaseUser: BaseUserModels;
  Boolean: Scalars['Boolean'];
  BroadCast: BroadCastModels;
  Coach: CoachModels;
  Date: Scalars['Date'];
  Excercise: ExcerciseModels;
  ExcerciseInput: ExcerciseInput;
  ExcerciseMetadata: ExcerciseMetadataModels;
  ExcercisePerformance: Omit<ExcercisePerformance, 'grouped_excercise_sets'> & { grouped_excercise_sets?: Maybe<Array<ResolversParentTypes['GroupedExcerciseSets']>> };
  ExcerciseSet: ExcerciseSetModels;
  ExcerciseSetGroup: ExcerciseSetGroupModels;
  ExerciseOneRepMaxDataPoint: ExerciseOneRepMaxDataPoint;
  ExerciseTotalVolumeDataPoint: ExerciseTotalVolumeDataPoint;
  FCMToken: FcmToken;
  Float: Scalars['Float'];
  GenerateIdTokenResponse: Omit<GenerateIdTokenResponse, 'token'> & { token?: Maybe<ResolversParentTypes['Token']> };
  GroupedExcerciseSets: Omit<GroupedExcerciseSets, 'excercise_sets'> & { excercise_sets?: Maybe<Array<ResolversParentTypes['ExcerciseSet']>> };
  ID: Scalars['ID'];
  Int: Scalars['Int'];
  Measurement: MeasurementModels;
  MuscleRegion: MuscleRegionModels;
  MutateBaseUserResponse: Omit<MutateBaseUserResponse, 'user'> & { user?: Maybe<ResolversParentTypes['BaseUser']> };
  MutateUserResponse: Omit<MutateUserResponse, 'user'> & { user?: Maybe<ResolversParentTypes['User']> };
  Mutation: {};
  MutationResponse: ResolversParentTypes['GenerateIdTokenResponse'] | ResolversParentTypes['MutateBaseUserResponse'] | ResolversParentTypes['MutateUserResponse'] | ResolversParentTypes['NotificationResponse'] | ResolversParentTypes['SignupResponse'] | ResolversParentTypes['mutateExcerciseMetaDataResponse'] | ResolversParentTypes['mutateMeasurementResponse'] | ResolversParentTypes['mutateMuscleRegionResponse'] | ResolversParentTypes['mutateProgramResponse'] | ResolversParentTypes['mutateWorkoutResponse'] | ResolversParentTypes['mutateWorkoutsResponse'];
  Notification: NotificationModels;
  NotificationResponse: NotificationResponse;
  Program: ProgramModels;
  Query: {};
  Review: Review;
  SignupResponse: SignupResponse;
  String: Scalars['String'];
  Token: TokenModels;
  User: UserModels;
  Workout: WorkoutModels;
  WorkoutAverageRPEDataPoint: WorkoutAverageRpeDataPoint;
  WorkoutFrequency: WorkoutFrequency;
  excerciseMetaDataInput: ExcerciseMetaDataInput;
  excerciseSetGroupInput: ExcerciseSetGroupInput;
  excerciseSetInput: ExcerciseSetInput;
  mutateExcerciseMetaDataResponse: Omit<MutateExcerciseMetaDataResponse, 'excercise_metadata'> & { excercise_metadata?: Maybe<ResolversParentTypes['ExcerciseMetadata']> };
  mutateMeasurementResponse: Omit<MutateMeasurementResponse, 'measurement'> & { measurement?: Maybe<ResolversParentTypes['Measurement']> };
  mutateMuscleRegionResponse: Omit<MutateMuscleRegionResponse, 'muscle_region'> & { muscle_region?: Maybe<ResolversParentTypes['MuscleRegion']> };
  mutateProgramResponse: Omit<MutateProgramResponse, 'program'> & { program?: Maybe<ResolversParentTypes['Program']> };
  mutateWorkoutResponse: Omit<MutateWorkoutResponse, 'workout'> & { workout?: Maybe<ResolversParentTypes['Workout']> };
  mutateWorkoutsResponse: Omit<MutateWorkoutsResponse, 'workouts'> & { workouts?: Maybe<Array<ResolversParentTypes['Workout']>> };
  workoutInput: WorkoutInput;
};

export type BaseUserResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['BaseUser'] = ResolversParentTypes['BaseUser']> = {
  User?: Resolver<Maybe<ResolversTypes['User']>, ParentType, ContextType>;
  base_user_id?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  coach?: Resolver<Maybe<ResolversTypes['Coach']>, ParentType, ContextType>;
  displayName?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  email?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  fcm_tokens?: Resolver<Maybe<Array<ResolversTypes['FCMToken']>>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type BroadCastResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['BroadCast'] = ResolversParentTypes['BroadCast']> = {
  broad_cast_id?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  broadcast_message?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  scheduled_end?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  scheduled_start?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type CoachResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['Coach'] = ResolversParentTypes['Coach']> = {
  Program?: Resolver<Array<Maybe<ResolversTypes['Program']>>, ParentType, ContextType>;
  Review?: Resolver<Array<Maybe<ResolversTypes['Review']>>, ParentType, ContextType>;
  coach_id?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  displayName?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  email?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  firebase_uid?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export interface DateScalarConfig extends GraphQLScalarTypeConfig<ResolversTypes['Date'], any> {
  name: 'Date';
}

export type ExcerciseResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['Excercise'] = ResolversParentTypes['Excercise']> = {
  assisted?: Resolver<Maybe<ResolversTypes['Boolean']>, ParentType, ContextType>;
  body_weight?: Resolver<Maybe<ResolversTypes['Boolean']>, ParentType, ContextType>;
  dynamic_stabilizer_muscles?: Resolver<Maybe<Array<ResolversTypes['MuscleRegion']>>, ParentType, ContextType>;
  equipment_required?: Resolver<Maybe<Array<ResolversTypes['Equipment']>>, ParentType, ContextType>;
  excercise_force?: Resolver<Maybe<Array<ResolversTypes['String']>>, ParentType, ContextType>;
  excercise_instructions?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  excercise_mechanics?: Resolver<Maybe<Array<ResolversTypes['String']>>, ParentType, ContextType>;
  excercise_metadata?: Resolver<Maybe<ResolversTypes['ExcerciseMetadata']>, ParentType, ContextType>;
  excercise_name?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  excercise_preparation?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  excercise_tips?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  excercise_utility?: Resolver<Maybe<Array<ResolversTypes['String']>>, ParentType, ContextType>;
  stabilizer_muscles?: Resolver<Maybe<Array<ResolversTypes['MuscleRegion']>>, ParentType, ContextType>;
  synergist_muscles?: Resolver<Maybe<Array<ResolversTypes['MuscleRegion']>>, ParentType, ContextType>;
  target_regions?: Resolver<Maybe<Array<ResolversTypes['MuscleRegion']>>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type ExcerciseMetadataResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['ExcerciseMetadata'] = ResolversParentTypes['ExcerciseMetadata']> = {
  best_rep?: Resolver<ResolversTypes['Int'], ParentType, ContextType>;
  best_weight?: Resolver<ResolversTypes['Float'], ParentType, ContextType>;
  excercise_metadata_state?: Resolver<ResolversTypes['ExcerciseMetadataState'], ParentType, ContextType>;
  excercise_name?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  haveRequiredEquipment?: Resolver<Maybe<ResolversTypes['Boolean']>, ParentType, ContextType>;
  last_excecuted?: Resolver<Maybe<ResolversTypes['Date']>, ParentType, ContextType>;
  preferred?: Resolver<Maybe<ResolversTypes['Boolean']>, ParentType, ContextType>;
  rest_time_lower_bound?: Resolver<ResolversTypes['Int'], ParentType, ContextType>;
  rest_time_upper_bound?: Resolver<ResolversTypes['Int'], ParentType, ContextType>;
  weight_unit?: Resolver<ResolversTypes['WeightUnit'], ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type ExcercisePerformanceResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['ExcercisePerformance'] = ResolversParentTypes['ExcercisePerformance']> = {
  grouped_excercise_sets?: Resolver<Maybe<Array<ResolversTypes['GroupedExcerciseSets']>>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type ExcerciseSetResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['ExcerciseSet'] = ResolversParentTypes['ExcerciseSet']> = {
  actual_reps?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  actual_weight?: Resolver<Maybe<ResolversTypes['Float']>, ParentType, ContextType>;
  excercise_set_id?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  rate_of_perceived_exertion?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  target_reps?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  target_weight?: Resolver<Maybe<ResolversTypes['Float']>, ParentType, ContextType>;
  weight_unit?: Resolver<Maybe<ResolversTypes['WeightUnit']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type ExcerciseSetGroupResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['ExcerciseSetGroup'] = ResolversParentTypes['ExcerciseSetGroup']> = {
  excercise?: Resolver<Maybe<ResolversTypes['Excercise']>, ParentType, ContextType>;
  excercise_metadata?: Resolver<Maybe<ResolversTypes['ExcerciseMetadata']>, ParentType, ContextType>;
  excercise_name?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  excercise_set_group_id?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  excercise_set_group_state?: Resolver<Maybe<ResolversTypes['ExcerciseSetGroupState']>, ParentType, ContextType>;
  excercise_sets?: Resolver<Array<ResolversTypes['ExcerciseSet']>, ParentType, ContextType>;
  failure_reason?: Resolver<Maybe<ResolversTypes['FailureReason']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type ExerciseOneRepMaxDataPointResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['ExerciseOneRepMaxDataPoint'] = ResolversParentTypes['ExerciseOneRepMaxDataPoint']> = {
  date_completed?: Resolver<Maybe<ResolversTypes['Date']>, ParentType, ContextType>;
  estimated_one_rep_max_value?: Resolver<Maybe<ResolversTypes['Float']>, ParentType, ContextType>;
  exercise_name?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type ExerciseTotalVolumeDataPointResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['ExerciseTotalVolumeDataPoint'] = ResolversParentTypes['ExerciseTotalVolumeDataPoint']> = {
  date_completed?: Resolver<Maybe<ResolversTypes['Date']>, ParentType, ContextType>;
  exercise_name?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  exercise_total_volume?: Resolver<Maybe<ResolversTypes['Float']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type FcmTokenResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['FCMToken'] = ResolversParentTypes['FCMToken']> = {
  date_issued?: Resolver<Maybe<ResolversTypes['Date']>, ParentType, ContextType>;
  token?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type GenerateIdTokenResponseResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['GenerateIdTokenResponse'] = ResolversParentTypes['GenerateIdTokenResponse']> = {
  code?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  message?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  success?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
  token?: Resolver<Maybe<ResolversTypes['Token']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type GroupedExcerciseSetsResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['GroupedExcerciseSets'] = ResolversParentTypes['GroupedExcerciseSets']> = {
  date_completed?: Resolver<Maybe<ResolversTypes['Date']>, ParentType, ContextType>;
  excercise_sets?: Resolver<Maybe<Array<ResolversTypes['ExcerciseSet']>>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type MeasurementResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['Measurement'] = ResolversParentTypes['Measurement']> = {
  length_units?: Resolver<Maybe<ResolversTypes['LengthUnit']>, ParentType, ContextType>;
  measured_at?: Resolver<Maybe<ResolversTypes['Date']>, ParentType, ContextType>;
  measurement_id?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  measurement_value?: Resolver<Maybe<ResolversTypes['Float']>, ParentType, ContextType>;
  muscle_region?: Resolver<Maybe<ResolversTypes['MuscleRegion']>, ParentType, ContextType>;
  user_id?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type MuscleRegionResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['MuscleRegion'] = ResolversParentTypes['MuscleRegion']> = {
  muscle_region_description?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  muscle_region_id?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  muscle_region_name?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  muscle_region_type?: Resolver<Maybe<ResolversTypes['MuscleRegionType']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type MutateBaseUserResponseResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['MutateBaseUserResponse'] = ResolversParentTypes['MutateBaseUserResponse']> = {
  code?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  message?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  success?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
  user?: Resolver<Maybe<ResolversTypes['BaseUser']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type MutateUserResponseResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['MutateUserResponse'] = ResolversParentTypes['MutateUserResponse']> = {
  code?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  message?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  success?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
  user?: Resolver<Maybe<ResolversTypes['User']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type MutationResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['Mutation'] = ResolversParentTypes['Mutation']> = {
  completeWorkout?: Resolver<Maybe<ResolversTypes['mutateWorkoutsResponse']>, ParentType, ContextType, RequireFields<MutationCompleteWorkoutArgs, 'excercise_set_groups' | 'workout_id'>>;
  createExcerciseMetadata?: Resolver<Maybe<ResolversTypes['mutateExcerciseMetaDataResponse']>, ParentType, ContextType, RequireFields<MutationCreateExcerciseMetadataArgs, 'excercise_name' | 'rest_time_lower_bound' | 'rest_time_upper_bound'>>;
  createMeasurement?: Resolver<Maybe<ResolversTypes['mutateMeasurementResponse']>, ParentType, ContextType, RequireFields<MutationCreateMeasurementArgs, 'length_units' | 'measured_at' | 'measurement_value' | 'muscle_region_id'>>;
  createMuscleRegion?: Resolver<Maybe<ResolversTypes['mutateMuscleRegionResponse']>, ParentType, ContextType, RequireFields<MutationCreateMuscleRegionArgs, 'muscle_region_description' | 'muscle_region_name' | 'muscle_region_type'>>;
  createProgram?: Resolver<Maybe<ResolversTypes['mutateProgramResponse']>, ParentType, ContextType, RequireFields<MutationCreateProgramArgs, 'user_id'>>;
  createWorkout?: Resolver<Maybe<ResolversTypes['mutateWorkoutResponse']>, ParentType, ContextType, RequireFields<MutationCreateWorkoutArgs, 'excercise_set_groups' | 'life_span' | 'workout_name' | 'workout_type'>>;
  deleteMeasurement?: Resolver<Maybe<ResolversTypes['mutateMeasurementResponse']>, ParentType, ContextType, RequireFields<MutationDeleteMeasurementArgs, 'measurement_id'>>;
  deleteMuscleRegion?: Resolver<Maybe<ResolversTypes['mutateMuscleRegionResponse']>, ParentType, ContextType, RequireFields<MutationDeleteMuscleRegionArgs, 'muscle_region_id'>>;
  deleteWorkout?: Resolver<Maybe<ResolversTypes['mutateWorkoutsResponse']>, ParentType, ContextType, RequireFields<MutationDeleteWorkoutArgs, 'workout_id'>>;
  generateFirebaseIdToken?: Resolver<Maybe<ResolversTypes['GenerateIdTokenResponse']>, ParentType, ContextType, RequireFields<MutationGenerateFirebaseIdTokenArgs, 'uid'>>;
  generateNotification?: Resolver<Maybe<ResolversTypes['NotificationResponse']>, ParentType, ContextType, RequireFields<MutationGenerateNotificationArgs, 'body' | 'title' | 'token'>>;
  generateWorkoutReminder?: Resolver<Maybe<ResolversTypes['NotificationResponse']>, ParentType, ContextType>;
  generateWorkouts?: Resolver<Maybe<Array<ResolversTypes['Workout']>>, ParentType, ContextType, RequireFields<MutationGenerateWorkoutsArgs, 'no_of_workouts'>>;
  regenerateWorkouts?: Resolver<Maybe<Array<ResolversTypes['Workout']>>, ParentType, ContextType>;
  signup?: Resolver<Maybe<ResolversTypes['SignupResponse']>, ParentType, ContextType, RequireFields<MutationSignupArgs, 'displayName' | 'email' | 'is_user' | 'password'>>;
  updateBaseUser?: Resolver<Maybe<ResolversTypes['MutateBaseUserResponse']>, ParentType, ContextType, Partial<MutationUpdateBaseUserArgs>>;
  updateExcerciseMetadata?: Resolver<Maybe<ResolversTypes['mutateExcerciseMetaDataResponse']>, ParentType, ContextType, RequireFields<MutationUpdateExcerciseMetadataArgs, 'excercise_name'>>;
  updateMeasurement?: Resolver<Maybe<ResolversTypes['mutateMeasurementResponse']>, ParentType, ContextType, RequireFields<MutationUpdateMeasurementArgs, 'measurement_id'>>;
  updateMuscleRegion?: Resolver<Maybe<ResolversTypes['mutateMuscleRegionResponse']>, ParentType, ContextType, RequireFields<MutationUpdateMuscleRegionArgs, 'muscle_region_id'>>;
  updateUser?: Resolver<Maybe<ResolversTypes['MutateUserResponse']>, ParentType, ContextType, Partial<MutationUpdateUserArgs>>;
  updateWorkout?: Resolver<Maybe<ResolversTypes['mutateWorkoutResponse']>, ParentType, ContextType, RequireFields<MutationUpdateWorkoutArgs, 'workout_id'>>;
  updateWorkoutOrder?: Resolver<Maybe<ResolversTypes['mutateWorkoutsResponse']>, ParentType, ContextType, RequireFields<MutationUpdateWorkoutOrderArgs, 'newIndex' | 'oldIndex' | 'workout_type'>>;
};

export type MutationResponseResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['MutationResponse'] = ResolversParentTypes['MutationResponse']> = {
  __resolveType: TypeResolveFn<'GenerateIdTokenResponse' | 'MutateBaseUserResponse' | 'MutateUserResponse' | 'NotificationResponse' | 'SignupResponse' | 'mutateExcerciseMetaDataResponse' | 'mutateMeasurementResponse' | 'mutateMuscleRegionResponse' | 'mutateProgramResponse' | 'mutateWorkoutResponse' | 'mutateWorkoutsResponse', ParentType, ContextType>;
  code?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  message?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  success?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
};

export type NotificationResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['Notification'] = ResolversParentTypes['Notification']> = {
  notification_id?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  notification_message?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  user_id?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type NotificationResponseResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['NotificationResponse'] = ResolversParentTypes['NotificationResponse']> = {
  code?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  message?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  success?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type ProgramResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['Program'] = ResolversParentTypes['Program']> = {
  coach_id?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  is_active?: Resolver<Maybe<ResolversTypes['Boolean']>, ParentType, ContextType>;
  program_id?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  user_id?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  workouts?: Resolver<Maybe<Array<ResolversTypes['Workout']>>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type QueryResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['Query'] = ResolversParentTypes['Query']> = {
  analyticsExerciseOneRepMax?: Resolver<Maybe<Array<Maybe<ResolversTypes['ExerciseOneRepMaxDataPoint']>>>, ParentType, ContextType, RequireFields<QueryAnalyticsExerciseOneRepMaxArgs, 'excercise_names_list'>>;
  analyticsExerciseTotalVolume?: Resolver<Maybe<Array<Maybe<ResolversTypes['ExerciseTotalVolumeDataPoint']>>>, ParentType, ContextType, RequireFields<QueryAnalyticsExerciseTotalVolumeArgs, 'excercise_names_list'>>;
  analyticsWorkoutAverageRPE?: Resolver<Maybe<Array<Maybe<ResolversTypes['WorkoutAverageRPEDataPoint']>>>, ParentType, ContextType>;
  baseUser?: Resolver<Maybe<ResolversTypes['BaseUser']>, ParentType, ContextType>;
  baseUsers?: Resolver<Maybe<Array<Maybe<ResolversTypes['BaseUser']>>>, ParentType, ContextType>;
  coachProgram?: Resolver<Maybe<ResolversTypes['Program']>, ParentType, ContextType, RequireFields<QueryCoachProgramArgs, 'program_id'>>;
  coachPrograms?: Resolver<Maybe<Array<Maybe<ResolversTypes['Program']>>>, ParentType, ContextType>;
  coachUsers?: Resolver<Maybe<Array<Maybe<ResolversTypes['BaseUser']>>>, ParentType, ContextType>;
  coachUsersNotRegistered?: Resolver<Maybe<Array<Maybe<ResolversTypes['BaseUser']>>>, ParentType, ContextType>;
  coachWorkoutName?: Resolver<Maybe<ResolversTypes['Workout']>, ParentType, ContextType, RequireFields<QueryCoachWorkoutNameArgs, 'programProgram_id' | 'user_id' | 'workout_name'>>;
  excercises?: Resolver<Maybe<Array<Maybe<ResolversTypes['Excercise']>>>, ParentType, ContextType>;
  excludedExcercises?: Resolver<Maybe<Array<Maybe<ResolversTypes['Excercise']>>>, ParentType, ContextType>;
  getExcercise?: Resolver<Maybe<ResolversTypes['Excercise']>, ParentType, ContextType, RequireFields<QueryGetExcerciseArgs, 'excercise_name'>>;
  getExcerciseMetadatas?: Resolver<Maybe<Array<Maybe<ResolversTypes['ExcerciseMetadata']>>>, ParentType, ContextType, RequireFields<QueryGetExcerciseMetadatasArgs, 'excercise_names_list'>>;
  getExcercisePerformance?: Resolver<Maybe<ResolversTypes['ExcercisePerformance']>, ParentType, ContextType, RequireFields<QueryGetExcercisePerformanceArgs, 'excercise_name'>>;
  getWorkout?: Resolver<Maybe<ResolversTypes['Workout']>, ParentType, ContextType, RequireFields<QueryGetWorkoutArgs, 'workout_id'>>;
  notifications?: Resolver<Maybe<Array<Maybe<ResolversTypes['Notification']>>>, ParentType, ContextType>;
  user?: Resolver<Maybe<ResolversTypes['User']>, ParentType, ContextType>;
  users?: Resolver<Maybe<Array<Maybe<ResolversTypes['User']>>>, ParentType, ContextType>;
  workout_frequencies?: Resolver<Maybe<Array<Maybe<ResolversTypes['WorkoutFrequency']>>>, ParentType, ContextType>;
  workouts?: Resolver<Maybe<Array<Maybe<ResolversTypes['Workout']>>>, ParentType, ContextType, RequireFields<QueryWorkoutsArgs, 'filter'>>;
};

export type ReviewResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['Review'] = ResolversParentTypes['Review']> = {
  content?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  rating?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  review_id?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type SignupResponseResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['SignupResponse'] = ResolversParentTypes['SignupResponse']> = {
  code?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  message?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  success?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type TokenResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['Token'] = ResolversParentTypes['Token']> = {
  expiresIn?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  idToken?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  isNewUser?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
  kind?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  refreshToken?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type UserResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['User'] = ResolversParentTypes['User']> = {
  age?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  ai_managed_workouts_life_cycle?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  automatic_scheduling?: Resolver<Maybe<ResolversTypes['Boolean']>, ParentType, ContextType>;
  body_weight_rep_lower_bound?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  body_weight_rep_upper_bound?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  compound_movement_rep_lower_bound?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  compound_movement_rep_upper_bound?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  dark_mode?: Resolver<Maybe<ResolversTypes['Boolean']>, ParentType, ContextType>;
  equipment_accessible?: Resolver<Maybe<Array<ResolversTypes['Equipment']>>, ParentType, ContextType>;
  gender?: Resolver<Maybe<ResolversTypes['Gender']>, ParentType, ContextType>;
  goal?: Resolver<Maybe<ResolversTypes['Goal']>, ParentType, ContextType>;
  height?: Resolver<Maybe<ResolversTypes['Float']>, ParentType, ContextType>;
  height_unit?: Resolver<Maybe<ResolversTypes['LengthUnit']>, ParentType, ContextType>;
  isolated_movement_rep_lower_bound?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  isolated_movement_rep_upper_bound?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  level_of_experience?: Resolver<Maybe<ResolversTypes['LevelOfExperience']>, ParentType, ContextType>;
  prior_years_of_experience?: Resolver<Maybe<ResolversTypes['Float']>, ParentType, ContextType>;
  program?: Resolver<Maybe<Array<ResolversTypes['Program']>>, ParentType, ContextType>;
  selected_exercise_for_analytics?: Resolver<Maybe<Array<ResolversTypes['Excercise']>>, ParentType, ContextType>;
  use_rpe?: Resolver<Maybe<ResolversTypes['Boolean']>, ParentType, ContextType>;
  user_id?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  weight?: Resolver<Maybe<ResolversTypes['Float']>, ParentType, ContextType>;
  weight_unit?: Resolver<Maybe<ResolversTypes['WeightUnit']>, ParentType, ContextType>;
  workout_duration?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  workout_frequency?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  workout_type_enrollment?: Resolver<Maybe<ResolversTypes['WorkoutType']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type WorkoutResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['Workout'] = ResolversParentTypes['Workout']> = {
  date_completed?: Resolver<Maybe<ResolversTypes['Date']>, ParentType, ContextType>;
  date_scheduled?: Resolver<Maybe<ResolversTypes['Date']>, ParentType, ContextType>;
  excercise_set_groups?: Resolver<Maybe<Array<ResolversTypes['ExcerciseSetGroup']>>, ParentType, ContextType>;
  life_span?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  order_index?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  performance_rating?: Resolver<Maybe<ResolversTypes['Float']>, ParentType, ContextType>;
  programProgram_id?: Resolver<Maybe<ResolversTypes['ID']>, ParentType, ContextType>;
  user_id?: Resolver<Maybe<ResolversTypes['ID']>, ParentType, ContextType>;
  workout_id?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  workout_name?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  workout_state?: Resolver<Maybe<ResolversTypes['WorkoutState']>, ParentType, ContextType>;
  workout_type?: Resolver<Maybe<ResolversTypes['WorkoutType']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type WorkoutAverageRpeDataPointResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['WorkoutAverageRPEDataPoint'] = ResolversParentTypes['WorkoutAverageRPEDataPoint']> = {
  average_rpe_value?: Resolver<Maybe<ResolversTypes['Float']>, ParentType, ContextType>;
  date_completed?: Resolver<Maybe<ResolversTypes['Date']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type WorkoutFrequencyResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['WorkoutFrequency'] = ResolversParentTypes['WorkoutFrequency']> = {
  week_identifier?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  workout_count?: Resolver<ResolversTypes['Int'], ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type MutateExcerciseMetaDataResponseResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['mutateExcerciseMetaDataResponse'] = ResolversParentTypes['mutateExcerciseMetaDataResponse']> = {
  code?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  excercise_metadata?: Resolver<Maybe<ResolversTypes['ExcerciseMetadata']>, ParentType, ContextType>;
  message?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  success?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type MutateMeasurementResponseResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['mutateMeasurementResponse'] = ResolversParentTypes['mutateMeasurementResponse']> = {
  code?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  measurement?: Resolver<Maybe<ResolversTypes['Measurement']>, ParentType, ContextType>;
  message?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  success?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type MutateMuscleRegionResponseResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['mutateMuscleRegionResponse'] = ResolversParentTypes['mutateMuscleRegionResponse']> = {
  code?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  message?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  muscle_region?: Resolver<Maybe<ResolversTypes['MuscleRegion']>, ParentType, ContextType>;
  success?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type MutateProgramResponseResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['mutateProgramResponse'] = ResolversParentTypes['mutateProgramResponse']> = {
  code?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  message?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  program?: Resolver<Maybe<ResolversTypes['Program']>, ParentType, ContextType>;
  success?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type MutateWorkoutResponseResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['mutateWorkoutResponse'] = ResolversParentTypes['mutateWorkoutResponse']> = {
  code?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  message?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  success?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
  workout?: Resolver<Maybe<ResolversTypes['Workout']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type MutateWorkoutsResponseResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['mutateWorkoutsResponse'] = ResolversParentTypes['mutateWorkoutsResponse']> = {
  code?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  message?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  success?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
  workouts?: Resolver<Maybe<Array<ResolversTypes['Workout']>>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type Resolvers<ContextType = AppContext> = {
  BaseUser?: BaseUserResolvers<ContextType>;
  BroadCast?: BroadCastResolvers<ContextType>;
  Coach?: CoachResolvers<ContextType>;
  Date?: GraphQLScalarType;
  Excercise?: ExcerciseResolvers<ContextType>;
  ExcerciseMetadata?: ExcerciseMetadataResolvers<ContextType>;
  ExcercisePerformance?: ExcercisePerformanceResolvers<ContextType>;
  ExcerciseSet?: ExcerciseSetResolvers<ContextType>;
  ExcerciseSetGroup?: ExcerciseSetGroupResolvers<ContextType>;
  ExerciseOneRepMaxDataPoint?: ExerciseOneRepMaxDataPointResolvers<ContextType>;
  ExerciseTotalVolumeDataPoint?: ExerciseTotalVolumeDataPointResolvers<ContextType>;
  FCMToken?: FcmTokenResolvers<ContextType>;
  GenerateIdTokenResponse?: GenerateIdTokenResponseResolvers<ContextType>;
  GroupedExcerciseSets?: GroupedExcerciseSetsResolvers<ContextType>;
  Measurement?: MeasurementResolvers<ContextType>;
  MuscleRegion?: MuscleRegionResolvers<ContextType>;
  MutateBaseUserResponse?: MutateBaseUserResponseResolvers<ContextType>;
  MutateUserResponse?: MutateUserResponseResolvers<ContextType>;
  Mutation?: MutationResolvers<ContextType>;
  MutationResponse?: MutationResponseResolvers<ContextType>;
  Notification?: NotificationResolvers<ContextType>;
  NotificationResponse?: NotificationResponseResolvers<ContextType>;
  Program?: ProgramResolvers<ContextType>;
  Query?: QueryResolvers<ContextType>;
  Review?: ReviewResolvers<ContextType>;
  SignupResponse?: SignupResponseResolvers<ContextType>;
  Token?: TokenResolvers<ContextType>;
  User?: UserResolvers<ContextType>;
  Workout?: WorkoutResolvers<ContextType>;
  WorkoutAverageRPEDataPoint?: WorkoutAverageRpeDataPointResolvers<ContextType>;
  WorkoutFrequency?: WorkoutFrequencyResolvers<ContextType>;
  mutateExcerciseMetaDataResponse?: MutateExcerciseMetaDataResponseResolvers<ContextType>;
  mutateMeasurementResponse?: MutateMeasurementResponseResolvers<ContextType>;
  mutateMuscleRegionResponse?: MutateMuscleRegionResponseResolvers<ContextType>;
  mutateProgramResponse?: MutateProgramResponseResolvers<ContextType>;
  mutateWorkoutResponse?: MutateWorkoutResponseResolvers<ContextType>;
  mutateWorkoutsResponse?: MutateWorkoutsResponseResolvers<ContextType>;
};

