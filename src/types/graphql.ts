import { GraphQLResolveInfo, GraphQLScalarType, GraphQLScalarTypeConfig } from 'graphql';
import { Token as Tokenmodel } from './tokenType';
import { BaseUser as BaseUsermodel, ProgramPreset as ProgramPresetmodel, PresetWorkouts as PresetWorkoutsmodel, PresetExcerciseSetGroup as PresetExcerciseSetGroupmodel, PresetExcerciseSet as PresetExcerciseSetmodel, ContentBlock as ContentBlockmodel, Coach as Coachmodel, Program as Programmodel, User as Usermodel, Workout as Workoutmodel, ExcerciseMetadata as ExcerciseMetadatamodel, Measurement as Measurementmodel, ExcerciseSetGroup as ExcerciseSetGroupmodel, MuscleRegion as MuscleRegionmodel, Excercise as Excercisemodel, ExcerciseSet as ExcerciseSetmodel, BroadCast as BroadCastmodel, Notification as Notificationmodel, CoachClientRelationship as CoachClientRelationshipmodel } from '@prisma/client';
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
  base_user_id: Scalars['ID'];
  coach?: Maybe<Coach>;
  displayName: Scalars['String'];
  email: Scalars['String'];
  fcm_tokens: Array<FcmToken>;
  firebase_uid: Scalars['String'];
  user?: Maybe<User>;
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
  Program?: Maybe<Array<Program>>;
  Review?: Maybe<Array<Review>>;
  coach_id: Scalars['ID'];
};

/** Represents broadcast message to selected users. */
export type CoachClientRelationship = {
  __typename?: 'CoachClientRelationship';
  active?: Maybe<Scalars['Boolean']>;
  coach?: Maybe<Coach>;
  date_created?: Maybe<Scalars['Date']>;
  user?: Maybe<User>;
};

/** Represents broadcast message to selected users. */
export type ContentBlock = {
  __typename?: 'ContentBlock';
  content_block_id: Scalars['ID'];
  content_block_type: ContentBlockType;
  description: Scalars['String'];
  title: Scalars['String'];
  video_url?: Maybe<Scalars['String']>;
};

export const ContentBlockType = {
  FeatureGuide: 'FEATURE_GUIDE',
  FitnessContent: 'FITNESS_CONTENT'
} as const;

export type ContentBlockType = typeof ContentBlockType[keyof typeof ContentBlockType];
export const Equipment = {
  Barbell: 'BARBELL',
  Bench: 'BENCH',
  Cable: 'CABLE',
  Dumbbell: 'DUMBBELL',
  Kettlebell: 'KETTLEBELL',
  Lever: 'LEVER',
  MedicineBall: 'MEDICINE_BALL',
  ParallelBars: 'PARALLEL_BARS',
  Preacher: 'PREACHER',
  PullUpBar: 'PULL_UP_BAR',
  Sled: 'SLED',
  Smith: 'SMITH',
  StabilityBall: 'STABILITY_BALL',
  Suspension: 'SUSPENSION',
  TrapBar: 'TRAP_BAR',
  TBar: 'T_BAR'
} as const;

export type Equipment = typeof Equipment[keyof typeof Equipment];
/** Represents a specific excercise. */
export type Excercise = {
  __typename?: 'Excercise';
  assisted: Scalars['Boolean'];
  body_weight: Scalars['Boolean'];
  dynamic_stabilizer_muscles: Array<MuscleRegion>;
  equipment_required: Array<Equipment>;
  excercise_force: Array<Scalars['String']>;
  excercise_instructions?: Maybe<Scalars['String']>;
  excercise_mechanics: Array<ExcerciseMechanics>;
  excercise_metadata?: Maybe<ExcerciseMetadata>;
  excercise_name: Scalars['ID'];
  excercise_preparation?: Maybe<Scalars['String']>;
  excercise_tips?: Maybe<Scalars['String']>;
  excercise_utility: Array<ExcerciseUtility>;
  stabilizer_muscles: Array<MuscleRegion>;
  synergist_muscles: Array<MuscleRegion>;
  target_regions: Array<MuscleRegion>;
  video_url?: Maybe<Scalars['String']>;
};

export type ExcerciseInput = {
  excercise_name: Scalars['String'];
};

export const ExcerciseMechanics = {
  Compound: 'COMPOUND',
  Isolated: 'ISOLATED'
} as const;

export type ExcerciseMechanics = typeof ExcerciseMechanics[keyof typeof ExcerciseMechanics];
/** Helps to store extra details of a user for a particular exercise. */
export type ExcerciseMetadata = {
  __typename?: 'ExcerciseMetadata';
  best_rep?: Maybe<Scalars['Int']>;
  best_weight?: Maybe<Scalars['Float']>;
  current_duration?: Maybe<Scalars['Int']>;
  estimated_historical_average_best_rep?: Maybe<Scalars['Int']>;
  estimated_historical_best_one_rep_max?: Maybe<Scalars['Float']>;
  excercise_metadata_state: ExcerciseMetadataState;
  excercise_name: Scalars['ID'];
  last_excecuted?: Maybe<Scalars['Date']>;
  preferred: Scalars['Boolean'];
  rest_time_lower_bound: Scalars['Int'];
  rest_time_upper_bound: Scalars['Int'];
  user_id: Scalars['ID'];
};

export const ExcerciseMetadataState = {
  DecreasedDifficulty: 'DECREASED_DIFFICULTY',
  IncreasedDifficulty: 'INCREASED_DIFFICULTY',
  Learning: 'LEARNING',
  Maintainence: 'MAINTAINENCE'
} as const;

export type ExcerciseMetadataState = typeof ExcerciseMetadataState[keyof typeof ExcerciseMetadataState];
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
  target_reps: Scalars['Int'];
  target_weight: Scalars['Float'];
  to_skip: Scalars['Boolean'];
};

export type ExcerciseSetGroup = {
  __typename?: 'ExcerciseSetGroup';
  excercise: Excercise;
  excercise_metadata: ExcerciseMetadata;
  excercise_name: Scalars['String'];
  excercise_set_group_id?: Maybe<Scalars['String']>;
  excercise_set_group_state: ExcerciseSetGroupState;
  excercise_sets: Array<ExcerciseSet>;
  failure_reason?: Maybe<FailureReason>;
};

/** Used in overloading algorithm to determine what to do with that set. */
export const ExcerciseSetGroupState = {
  DeletedPermanantly: 'DELETED_PERMANANTLY',
  DeletedTemporarily: 'DELETED_TEMPORARILY',
  NormalOperation: 'NORMAL_OPERATION',
  ReplacementPermanantly: 'REPLACEMENT_PERMANANTLY',
  ReplacementTemporarily: 'REPLACEMENT_TEMPORARILY'
} as const;

export type ExcerciseSetGroupState = typeof ExcerciseSetGroupState[keyof typeof ExcerciseSetGroupState];
export const ExcerciseUtility = {
  Auxiliary: 'AUXILIARY',
  Basic: 'BASIC'
} as const;

export type ExcerciseUtility = typeof ExcerciseUtility[keyof typeof ExcerciseUtility];
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
  date_issued: Scalars['Date'];
  token: Scalars['String'];
};

export const FailureReason = {
  InsufficientRestTime: 'INSUFFICIENT_REST_TIME',
  InsufficientSleep: 'INSUFFICIENT_SLEEP',
  InsufficientTime: 'INSUFFICIENT_TIME',
  LowMood: 'LOW_MOOD',
  TooDifficult: 'TOO_DIFFICULT'
} as const;

export type FailureReason = typeof FailureReason[keyof typeof FailureReason];
/** Gender type. */
export const Gender = {
  Female: 'FEMALE',
  Male: 'MALE',
  RatherNotSay: 'RATHER_NOT_SAY'
} as const;

export type Gender = typeof Gender[keyof typeof Gender];
/** Response if a token generation event is successful */
export type GenerateIdTokenResponse = MutationResponse & {
  __typename?: 'GenerateIdTokenResponse';
  code: Scalars['String'];
  message: Scalars['String'];
  success: Scalars['Boolean'];
  token?: Maybe<Token>;
};

export const Goal = {
  Athleticism: 'ATHLETICISM',
  BodyRecomposition: 'BODY_RECOMPOSITION',
  KeepingFit: 'KEEPING_FIT',
  Others: 'OTHERS',
  Strength: 'STRENGTH'
} as const;

export type Goal = typeof Goal[keyof typeof Goal];
export type GroupedExcerciseSets = {
  __typename?: 'GroupedExcerciseSets';
  date_completed?: Maybe<Scalars['Date']>;
  excercise_sets?: Maybe<Array<ExcerciseSet>>;
};

/** Units for length. */
export const LengthUnit = {
  Cm: 'CM',
  Ft: 'FT',
  Mm: 'MM',
  Mtr: 'MTR'
} as const;

export type LengthUnit = typeof LengthUnit[keyof typeof LengthUnit];
export const LevelOfExperience = {
  Advanced: 'ADVANCED',
  Beginner: 'BEGINNER',
  Expert: 'EXPERT',
  Mid: 'MID'
} as const;

export type LevelOfExperience = typeof LevelOfExperience[keyof typeof LevelOfExperience];
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

export const MuscleRegionType = {
  Back: 'BACK',
  Calves: 'CALVES',
  Chest: 'CHEST',
  ForeArm: 'FORE_ARM',
  Hips: 'HIPS',
  Neck: 'NECK',
  Shoulder: 'SHOULDER',
  Thighs: 'THIGHS',
  UpperArm: 'UPPER_ARM',
  Waist: 'WAIST'
} as const;

export type MuscleRegionType = typeof MuscleRegionType[keyof typeof MuscleRegionType];
/** Response if a mutation event is successful */
export type MutateBaseUserResponse = MutationResponse & {
  __typename?: 'MutateBaseUserResponse';
  code: Scalars['String'];
  message: Scalars['String'];
  success: Scalars['Boolean'];
  user?: Maybe<BaseUser>;
};

/** Response if a PrivateMessage event is successful */
export type MutatePrivateMessageResponse = MutationResponse & {
  __typename?: 'MutatePrivateMessageResponse';
  code: Scalars['String'];
  message: Scalars['String'];
  privateMessage?: Maybe<PrivateMessage>;
  success: Scalars['Boolean'];
};

/** Response if a mutation event is successful */
export type MutateUserResponse = MutationResponse & {
  __typename?: 'MutateUserResponse';
  code: Scalars['String'];
  message: Scalars['String'];
  success: Scalars['Boolean'];
  user?: Maybe<User>;
};

/** [PROTECTED] Mutation to create a programPreset */
export type Mutation = {
  __typename?: 'Mutation';
  /** [PROTECTED] Updates a workout object (Must belong to the requestor). Note: This will replace any existing excercise sets. */
  completeWorkout?: Maybe<MutateWorkoutResponse>;
  createCoachClientRelationship?: Maybe<MutateCoachClientRelationship>;
  createExcerciseMetadata?: Maybe<MutateExcerciseMetaDataResponse>;
  /** [PROTECTED] Creates a measurement object for the requestor. */
  createMeasurement?: Maybe<MutateMeasurementResponse>;
  /** [PROTECTED] Creates a muscle region object. */
  createMuscleRegion?: Maybe<MutateMuscleRegionResponse>;
  /** [PROTECTED] Creates a PrivateMessage Object. */
  createPrivateMessage?: Maybe<MutatePrivateMessageResponse>;
  /** [PROTECTED] Creates a program object. */
  createProgram: MutateProgramResponse;
  createProgramPreset?: Maybe<PresetResponse>;
  /** [PROTECTED] Creates a workout object for the requestor. */
  createWorkout?: Maybe<MutateWorkoutResponse>;
  /** [PROTECTED] Updates a excerciseMetadata object. */
  deleteCoachClientRelationship?: Maybe<MutateCoachClientRelationship>;
  /** [PROTECTED] Deletes a measurement object for the requestor (Must belong to the requestor). */
  deleteMeasurement?: Maybe<MutateMeasurementResponse>;
  /** [PROTECTED] Deletes a muscle region object. */
  deleteMuscleRegion?: Maybe<MutateMuscleRegionResponse>;
  /** [PROTECTED] Deletes a PrivateMessage Object. */
  deletePrivateMessage?: Maybe<MutationResponse>;
  /** [PROTECTED] Deletes a program object. */
  deleteProgram: MutateProgramResponse;
  /** [PROTECTED] Mutation to delete a programPreset */
  deleteProgramPreset?: Maybe<PresetResponse>;
  /** [PROTECTED] Deletes a workout object (Must belong to the requestor). */
  deleteWorkout?: Maybe<MutateWorkoutResponse>;
  /** [PROTECTED] ends an active program object (ONLY COACH). */
  endActiveProgram: MutateProgramResponse;
  generateFirebaseIdToken?: Maybe<GenerateIdTokenResponse>;
  generateNotification?: Maybe<NotificationResponse>;
  generateProgram: Program;
  generateWorkoutReminder?: Maybe<NotificationResponse>;
  refreshProgram: Program;
  signup?: Maybe<SignupResponse>;
  updateBaseUser?: Maybe<MutateBaseUserResponse>;
  updateCoachClientRelationship?: Maybe<MutateCoachClientRelationship>;
  /** [PROTECTED] Updates a excerciseMetadata object. */
  updateExcerciseMetadata?: Maybe<MutateExcerciseMetaDataResponse>;
  /** [PROTECTED] Update a measurement object for the requestor (Must belong to the requestor). */
  updateMeasurement?: Maybe<MutateMeasurementResponse>;
  /** [PROTECTED] Updates a muscle region object. */
  updateMuscleRegion?: Maybe<MutateMuscleRegionResponse>;
  /** [PROTECTED] Updates a program object. coach_id is the new coach_id */
  updateProgram: MutateProgramResponse;
  updateUser?: Maybe<MutateUserResponse>;
  /** [PROTECTED] Updates a workout object (Must belong to the requestor). Note: This will replace any existing excercise sets. */
  updateWorkout?: Maybe<MutateWorkoutResponse>;
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationCompleteWorkoutArgs = {
  excercise_set_groups: Array<ExcerciseSetGroupInput>;
  workout_id: Scalars['ID'];
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationCreateCoachClientRelationshipArgs = {
  coach_id?: InputMaybe<Scalars['ID']>;
  user_id?: InputMaybe<Scalars['ID']>;
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationCreateExcerciseMetadataArgs = {
  best_rep?: InputMaybe<Scalars['Int']>;
  best_weight?: InputMaybe<Scalars['Float']>;
  estimated_historical_average_best_rep?: InputMaybe<Scalars['Int']>;
  estimated_historical_best_one_rep_max?: InputMaybe<Scalars['Float']>;
  excercise_metadata_state?: InputMaybe<ExcerciseMetadataState>;
  excercise_name: Scalars['ID'];
  haveRequiredEquipment?: InputMaybe<Scalars['Boolean']>;
  last_excecuted?: InputMaybe<Scalars['Date']>;
  preferred?: InputMaybe<Scalars['Boolean']>;
  rest_time_lower_bound?: InputMaybe<Scalars['Int']>;
  rest_time_upper_bound?: InputMaybe<Scalars['Int']>;
  user_id: Scalars['ID'];
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationCreateMeasurementArgs = {
  length_units: LengthUnit;
  measured_at: Scalars['Date'];
  measurement_value: Scalars['Float'];
  muscle_region_id: Scalars['ID'];
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationCreateMuscleRegionArgs = {
  muscle_region_description: Scalars['String'];
  muscle_region_name: Scalars['String'];
  muscle_region_type: MuscleRegionType;
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationCreatePrivateMessageArgs = {
  message_content: Scalars['String'];
  receiver_id: Scalars['ID'];
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationCreateProgramArgs = {
  coach_id?: InputMaybe<Scalars['ID']>;
  ending_date?: InputMaybe<Scalars['Date']>;
  program_type: ProgramType;
  starting_date?: InputMaybe<Scalars['Date']>;
  user_id?: InputMaybe<Scalars['ID']>;
  workoutsInput: Array<WorkoutInput>;
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationCreateProgramPresetArgs = {
  image_url?: InputMaybe<Scalars['String']>;
  preset_difficulty: PresetDifficulty;
  preset_name: Scalars['String'];
  preset_workouts: Array<PresetWorkoutInput>;
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationCreateWorkoutArgs = {
  coach_id?: InputMaybe<Scalars['ID']>;
  date_scheduled: Scalars['Date'];
  excercise_set_groups: Array<ExcerciseSetGroupInput>;
  program_id: Scalars['ID'];
  user_id: Scalars['ID'];
  workout_name: Scalars['String'];
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationDeleteCoachClientRelationshipArgs = {
  coach_id?: InputMaybe<Scalars['ID']>;
  user_id?: InputMaybe<Scalars['ID']>;
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationDeleteMeasurementArgs = {
  measurement_id: Scalars['ID'];
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationDeleteMuscleRegionArgs = {
  muscle_region_id: Scalars['ID'];
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationDeletePrivateMessageArgs = {
  message_id: Scalars['ID'];
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationDeleteProgramArgs = {
  program_id: Scalars['ID'];
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationDeleteProgramPresetArgs = {
  programPreset_id: Scalars['ID'];
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationDeleteWorkoutArgs = {
  workout_id: Scalars['ID'];
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationEndActiveProgramArgs = {
  user_id: Scalars['ID'];
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationGenerateFirebaseIdTokenArgs = {
  uid: Scalars['String'];
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationGenerateNotificationArgs = {
  body: Scalars['String'];
  title: Scalars['String'];
  token: Scalars['String'];
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationGenerateProgramArgs = {
  initial_days: Array<Scalars['Date']>;
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationRefreshProgramArgs = {
  initial_days?: InputMaybe<Array<Scalars['Date']>>;
  program_id: Scalars['ID'];
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationSignupArgs = {
  displayName: Scalars['String'];
  email: Scalars['String'];
  is_user: Scalars['Boolean'];
  password: Scalars['String'];
  phoneNumber?: InputMaybe<Scalars['String']>;
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationUpdateBaseUserArgs = {
  displayName?: InputMaybe<Scalars['String']>;
  email?: InputMaybe<Scalars['String']>;
  fcm_tokens?: InputMaybe<Array<InputMaybe<Scalars['String']>>>;
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationUpdateCoachClientRelationshipArgs = {
  active: Scalars['Boolean'];
  coach_id?: InputMaybe<Scalars['ID']>;
  user_id?: InputMaybe<Scalars['ID']>;
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationUpdateExcerciseMetadataArgs = {
  best_rep?: InputMaybe<Scalars['Int']>;
  best_weight?: InputMaybe<Scalars['Float']>;
  estimated_historical_average_best_rep?: InputMaybe<Scalars['Int']>;
  estimated_historical_best_one_rep_max?: InputMaybe<Scalars['Float']>;
  excercise_metadata_state: ExcerciseMetadataState;
  excercise_name: Scalars['ID'];
  haveRequiredEquipment?: InputMaybe<Scalars['Boolean']>;
  last_excecuted?: InputMaybe<Scalars['Date']>;
  preferred?: InputMaybe<Scalars['Boolean']>;
  rest_time_lower_bound?: InputMaybe<Scalars['Int']>;
  rest_time_upper_bound?: InputMaybe<Scalars['Int']>;
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationUpdateMeasurementArgs = {
  length_units?: InputMaybe<LengthUnit>;
  measured_at?: InputMaybe<Scalars['Date']>;
  measurement_id: Scalars['ID'];
  measurement_value?: InputMaybe<Scalars['Float']>;
  muscle_region_id?: InputMaybe<Scalars['Int']>;
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationUpdateMuscleRegionArgs = {
  muscle_region_description?: InputMaybe<Scalars['String']>;
  muscle_region_id: Scalars['ID'];
  muscle_region_name?: InputMaybe<Scalars['String']>;
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationUpdateProgramArgs = {
  coach_id?: InputMaybe<Scalars['ID']>;
  ending_date?: InputMaybe<Scalars['Date']>;
  is_active?: InputMaybe<Scalars['Boolean']>;
  program_id: Scalars['ID'];
  program_type?: InputMaybe<ProgramType>;
  starting_date?: InputMaybe<Scalars['Date']>;
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationUpdateUserArgs = {
  age?: InputMaybe<Scalars['Int']>;
  body_weight_rep_lower_bound?: InputMaybe<Scalars['Int']>;
  body_weight_rep_upper_bound?: InputMaybe<Scalars['Int']>;
  compound_movement_rep_lower_bound?: InputMaybe<Scalars['Int']>;
  compound_movement_rep_upper_bound?: InputMaybe<Scalars['Int']>;
  current_program_enrollment_id?: InputMaybe<Scalars['Int']>;
  dark_mode?: InputMaybe<Scalars['Boolean']>;
  equipment_accessible?: InputMaybe<Array<Equipment>>;
  fcm_token?: InputMaybe<Array<Scalars['String']>>;
  gender?: InputMaybe<Gender>;
  goal?: InputMaybe<Goal>;
  height?: InputMaybe<Scalars['Float']>;
  height_unit?: InputMaybe<LengthUnit>;
  isolated_movement_rep_lower_bound?: InputMaybe<Scalars['Int']>;
  isolated_movement_rep_upper_bound?: InputMaybe<Scalars['Int']>;
  level_of_experience?: InputMaybe<LevelOfExperience>;
  phoneNumber?: InputMaybe<Scalars['String']>;
  prior_years_of_experience?: InputMaybe<Scalars['Float']>;
  selected_exercise_for_analytics?: InputMaybe<Array<Scalars['String']>>;
  use_rpe?: InputMaybe<Scalars['Boolean']>;
  weight?: InputMaybe<Scalars['Float']>;
  weight_unit?: InputMaybe<WeightUnit>;
  workout_duration?: InputMaybe<Scalars['Int']>;
  workout_frequency?: InputMaybe<Scalars['Int']>;
};


/** [PROTECTED] Mutation to create a programPreset */
export type MutationUpdateWorkoutArgs = {
  date_scheduled?: InputMaybe<Scalars['Date']>;
  excercise_set_groups?: InputMaybe<Array<ExcerciseSetGroupInput>>;
  performance_rating?: InputMaybe<Scalars['Float']>;
  workout_id: Scalars['ID'];
  workout_name?: InputMaybe<Scalars['String']>;
  workout_state?: InputMaybe<WorkoutState>;
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

export const PresetDifficulty = {
  Easy: 'EASY',
  Hard: 'HARD',
  Normal: 'NORMAL',
  VeryHard: 'VERY_HARD'
} as const;

export type PresetDifficulty = typeof PresetDifficulty[keyof typeof PresetDifficulty];
/** Represents an excercise set group Preset. */
export type PresetExcerciseSet = {
  __typename?: 'PresetExcerciseSet';
  preset_excercise_set_group_id?: Maybe<Scalars['Int']>;
  preset_excercise_set_id: Scalars['Int'];
  target_reps?: Maybe<Scalars['Int']>;
  target_weight?: Maybe<Scalars['Float']>;
};

export type PresetExcerciseSetGroup = {
  __typename?: 'PresetExcerciseSetGroup';
  excercise_name: Scalars['String'];
  preset_excercise_set_group_id: Scalars['Int'];
  preset_excercise_sets: Array<PresetExcerciseSet>;
  preset_workout_id?: Maybe<Scalars['Int']>;
};

export type PresetExcerciseSetGroupInput = {
  excercise_name: Scalars['String'];
  preset_excercise_sets: Array<PresetExcerciseSetInput>;
};

export type PresetExcerciseSetInput = {
  target_reps?: InputMaybe<Scalars['Int']>;
  target_weight?: InputMaybe<Scalars['Float']>;
};

export type PresetWorkoutInput = {
  preset_excercise_set_groups: Array<PresetExcerciseSetGroupInput>;
  rest_day?: InputMaybe<Scalars['Boolean']>;
};

export type PresetWorkouts = {
  __typename?: 'PresetWorkouts';
  preset_excercise_set_groups: Array<PresetExcerciseSetGroup>;
  preset_workout_id: Scalars['Int'];
  program_preset_id?: Maybe<Scalars['Int']>;
  rest_day?: Maybe<Scalars['Boolean']>;
};

/** Represents a list of private messages. */
export type PrivateMessage = {
  __typename?: 'PrivateMessage';
  date_issued?: Maybe<Scalars['Date']>;
  message_content: Scalars['String'];
  message_id?: Maybe<Scalars['Int']>;
  receiver_id?: Maybe<Scalars['Int']>;
  sender_id?: Maybe<Scalars['Int']>;
};

/** Represents programs for coaches. */
export type Program = {
  __typename?: 'Program';
  coach?: Maybe<Coach>;
  ending_date?: Maybe<Scalars['Date']>;
  is_active: Scalars['Boolean'];
  program_id: Scalars['ID'];
  program_type: ProgramType;
  starting_date: Scalars['Date'];
  user: User;
  workouts: Array<Workout>;
};


/** Represents programs for coaches. */
export type ProgramWorkoutsArgs = {
  coach_id?: InputMaybe<Scalars['ID']>;
  user_id?: InputMaybe<Scalars['ID']>;
  workout_filter?: InputMaybe<WorkoutQueryFilter>;
};

/** Represents a challenge Preset. */
export type ProgramPreset = {
  __typename?: 'ProgramPreset';
  coach_id?: Maybe<Scalars['Int']>;
  image_url?: Maybe<Scalars['String']>;
  preset_difficulty?: Maybe<PresetDifficulty>;
  preset_name?: Maybe<Scalars['String']>;
  preset_workouts: Array<PresetWorkouts>;
  programPreset_id: Scalars['Int'];
};

export const ProgramType = {
  AiManaged: 'AI_MANAGED',
  CoachManaged: 'COACH_MANAGED',
  SelfManaged: 'SELF_MANAGED'
} as const;

export type ProgramType = typeof ProgramType[keyof typeof ProgramType];
/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type Query = {
  __typename?: 'Query';
  analyticsExerciseOneRepMax: Array<ExerciseOneRepMaxDataPoint>;
  analyticsExerciseTotalVolume: Array<ExerciseTotalVolumeDataPoint>;
  analyticsWorkoutAverageRPE: Array<WorkoutAverageRpeDataPoint>;
  baseUser: BaseUser;
  excercises: Array<Excercise>;
  excludedExcercises: Array<Excercise>;
  getCoachClientRelationship: CoachClientRelationship;
  getCoachClientRelationships: Array<CoachClientRelationship>;
  getContentBlocks: Array<ContentBlock>;
  getExcercise: Excercise;
  getExcerciseMetadatas: Array<ExcerciseMetadata>;
  getExcercisePerformance: ExcercisePerformance;
  getPrivateMessages: Array<PrivateMessage>;
  notifications: Array<Notification>;
  preset: ProgramPreset;
  presets: Array<ProgramPreset>;
  previousWorkout?: Maybe<Workout>;
  program: Program;
  programs: Array<Program>;
  user: User;
  users: Array<User>;
  workout: Workout;
  workout_frequencies: Array<WorkoutFrequency>;
  workouts: Array<Workout>;
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryAnalyticsExerciseOneRepMaxArgs = {
  excercise_names_list: Array<Scalars['ID']>;
  user_id?: InputMaybe<Scalars['ID']>;
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryAnalyticsExerciseTotalVolumeArgs = {
  excercise_names_list: Array<Scalars['ID']>;
  user_id?: InputMaybe<Scalars['ID']>;
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryGetCoachClientRelationshipArgs = {
  coach_id?: InputMaybe<Scalars['ID']>;
  user_id?: InputMaybe<Scalars['ID']>;
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryGetContentBlocksArgs = {
  content_block_type: ContentBlockType;
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryGetExcerciseArgs = {
  excercise_name: Scalars['ID'];
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryGetExcerciseMetadatasArgs = {
  excercise_names_list: Array<Scalars['ID']>;
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryGetExcercisePerformanceArgs = {
  excercise_name: Scalars['ID'];
  span?: InputMaybe<Scalars['Int']>;
  user_id?: InputMaybe<Scalars['ID']>;
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryGetPrivateMessagesArgs = {
  pair_id: Scalars['ID'];
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryPresetArgs = {
  programPreset_id: Scalars['ID'];
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryPreviousWorkoutArgs = {
  program_id: Scalars['ID'];
  workout_name: Scalars['String'];
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryProgramArgs = {
  filter?: InputMaybe<ProgramQueryFilter>;
  program_id?: InputMaybe<Scalars['ID']>;
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryProgramsArgs = {
  coach_id?: InputMaybe<Scalars['ID']>;
  user_id?: InputMaybe<Scalars['ID']>;
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryUsersArgs = {
  coach_filters?: InputMaybe<UserQueryCoachFilter>;
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryWorkoutArgs = {
  coach_id?: InputMaybe<Scalars['ID']>;
  previous: Scalars['Boolean'];
  user_id: Scalars['ID'];
  workout_id: Scalars['ID'];
};


/** This is the root query to resources. Require ADMIN permission to access all, otherwise resources are scoped to the user issuing the request. */
export type QueryWorkoutsArgs = {
  coach_id?: InputMaybe<Scalars['ID']>;
  filter: WorkoutQueryFilter;
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
  base_user?: Maybe<BaseUser>;
  base_user_id: Scalars['ID'];
  body_weight_rep_lower_bound: Scalars['Int'];
  body_weight_rep_upper_bound: Scalars['Int'];
  broadcasts: Array<BroadCast>;
  compound_movement_rep_lower_bound: Scalars['Int'];
  compound_movement_rep_upper_bound: Scalars['Int'];
  current_program_enrollment_id?: Maybe<Scalars['Int']>;
  dark_mode: Scalars['Boolean'];
  equipment_accessible: Array<Equipment>;
  excercise_metadata: Array<ExcerciseMetadata>;
  gender: Gender;
  goal?: Maybe<Goal>;
  height?: Maybe<Scalars['Float']>;
  height_unit: LengthUnit;
  isolated_movement_rep_lower_bound: Scalars['Int'];
  isolated_movement_rep_upper_bound: Scalars['Int'];
  level_of_experience?: Maybe<LevelOfExperience>;
  measurements: Array<Measurement>;
  notifications: Array<Notification>;
  prior_years_of_experience?: Maybe<Scalars['Float']>;
  program: Array<Program>;
  selected_exercise_for_analytics: Array<Excercise>;
  signup_date: Scalars['Date'];
  use_rpe: Scalars['Boolean'];
  user_id: Scalars['ID'];
  weight?: Maybe<Scalars['Float']>;
  weight_unit: WeightUnit;
  workout_duration?: Maybe<Scalars['Int']>;
  workout_frequency?: Maybe<Scalars['Int']>;
};

export type UserQueryCoachFilter = {
  active?: InputMaybe<Scalars['Boolean']>;
  clients?: InputMaybe<Scalars['Boolean']>;
};

/** Units for weight */
export const WeightUnit = {
  Kg: 'KG',
  Lb: 'LB'
} as const;

export type WeightUnit = typeof WeightUnit[keyof typeof WeightUnit];
/** Represents a user. Contains meta-data specific to each user. */
export type Workout = {
  __typename?: 'Workout';
  date_closed?: Maybe<Scalars['Date']>;
  date_scheduled: Scalars['Date'];
  excercise_set_groups: Array<ExcerciseSetGroup>;
  last_completed?: Maybe<Scalars['Date']>;
  performance_rating?: Maybe<Scalars['Float']>;
  program?: Maybe<Program>;
  programProgram_id: Scalars['ID'];
  workout_id: Scalars['ID'];
  workout_name: Scalars['String'];
  workout_state?: Maybe<WorkoutState>;
};

export type WorkoutAverageRpeDataPoint = {
  __typename?: 'WorkoutAverageRPEDataPoint';
  average_rpe_value?: Maybe<Scalars['Float']>;
  date_completed?: Maybe<Scalars['Date']>;
};

/** Units for weight */
export const WorkoutFilter = {
  Active: 'ACTIVE',
  Completed: 'COMPLETED',
  None: 'NONE'
} as const;

export type WorkoutFilter = typeof WorkoutFilter[keyof typeof WorkoutFilter];
/** Represents a user. Contains meta-data specific to each user. */
export type WorkoutFrequency = {
  __typename?: 'WorkoutFrequency';
  week_identifier?: Maybe<Scalars['String']>;
  workout_count: Scalars['Int'];
};

export type WorkoutQueryFilter = {
  completed?: InputMaybe<Scalars['Boolean']>;
  program_id?: InputMaybe<Scalars['ID']>;
  program_type?: InputMaybe<ProgramType>;
  upcoming?: InputMaybe<Scalars['Boolean']>;
  workout_name?: InputMaybe<Scalars['String']>;
};

export const WorkoutState = {
  Cancelled: 'CANCELLED',
  Completed: 'COMPLETED',
  InProgress: 'IN_PROGRESS',
  Unattempted: 'UNATTEMPTED'
} as const;

export type WorkoutState = typeof WorkoutState[keyof typeof WorkoutState];
export const CoachUserFilter = {
  Active: 'ACTIVE',
  None: 'NONE'
} as const;

export type CoachUserFilter = typeof CoachUserFilter[keyof typeof CoachUserFilter];
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
  to_skip: Scalars['Boolean'];
};

/** Response if mutating a excercise was successful */
export type MutateCoachClientRelationship = MutationResponse & {
  __typename?: 'mutateCoachClientRelationship';
  client_coach_relationship?: Maybe<CoachClientRelationship>;
  code: Scalars['String'];
  message: Scalars['String'];
  success: Scalars['Boolean'];
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

/** Response if a mutation event is successful */
export type PresetResponse = MutationResponse & {
  __typename?: 'presetResponse';
  code: Scalars['String'];
  message: Scalars['String'];
  success: Scalars['Boolean'];
};

export type ProgramQueryFilter = {
  is_active?: InputMaybe<Scalars['Boolean']>;
  overview_mode?: InputMaybe<Scalars['Boolean']>;
  program_type?: InputMaybe<ProgramType>;
  user_id?: InputMaybe<Scalars['ID']>;
};

export type WorkoutInput = {
  date_closed?: InputMaybe<Scalars['Date']>;
  date_scheduled: Scalars['Date'];
  excercise_set_groups: Array<ExcerciseSetGroupInput>;
  workout_name: Scalars['String'];
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
  BaseUser: ResolverTypeWrapper<BaseUsermodel>;
  Boolean: ResolverTypeWrapper<Scalars['Boolean']>;
  BroadCast: ResolverTypeWrapper<BroadCastmodel>;
  Coach: ResolverTypeWrapper<Coachmodel>;
  CoachClientRelationship: ResolverTypeWrapper<CoachClientRelationshipmodel>;
  ContentBlock: ResolverTypeWrapper<ContentBlockmodel>;
  ContentBlockType: ContentBlockType;
  Date: ResolverTypeWrapper<Scalars['Date']>;
  Equipment: Equipment;
  Excercise: ResolverTypeWrapper<Excercisemodel>;
  ExcerciseInput: ExcerciseInput;
  ExcerciseMechanics: ExcerciseMechanics;
  ExcerciseMetadata: ResolverTypeWrapper<ExcerciseMetadatamodel>;
  ExcerciseMetadataState: ExcerciseMetadataState;
  ExcercisePerformance: ResolverTypeWrapper<Omit<ExcercisePerformance, 'grouped_excercise_sets'> & { grouped_excercise_sets?: Maybe<Array<ResolversTypes['GroupedExcerciseSets']>> }>;
  ExcerciseSet: ResolverTypeWrapper<ExcerciseSetmodel>;
  ExcerciseSetGroup: ResolverTypeWrapper<ExcerciseSetGroupmodel>;
  ExcerciseSetGroupState: ExcerciseSetGroupState;
  ExcerciseUtility: ExcerciseUtility;
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
  Measurement: ResolverTypeWrapper<Measurementmodel>;
  MuscleRegion: ResolverTypeWrapper<MuscleRegionmodel>;
  MuscleRegionType: MuscleRegionType;
  MutateBaseUserResponse: ResolverTypeWrapper<Omit<MutateBaseUserResponse, 'user'> & { user?: Maybe<ResolversTypes['BaseUser']> }>;
  MutatePrivateMessageResponse: ResolverTypeWrapper<MutatePrivateMessageResponse>;
  MutateUserResponse: ResolverTypeWrapper<Omit<MutateUserResponse, 'user'> & { user?: Maybe<ResolversTypes['User']> }>;
  Mutation: ResolverTypeWrapper<{}>;
  MutationResponse: ResolversTypes['GenerateIdTokenResponse'] | ResolversTypes['MutateBaseUserResponse'] | ResolversTypes['MutatePrivateMessageResponse'] | ResolversTypes['MutateUserResponse'] | ResolversTypes['NotificationResponse'] | ResolversTypes['SignupResponse'] | ResolversTypes['mutateCoachClientRelationship'] | ResolversTypes['mutateExcerciseMetaDataResponse'] | ResolversTypes['mutateMeasurementResponse'] | ResolversTypes['mutateMuscleRegionResponse'] | ResolversTypes['mutateProgramResponse'] | ResolversTypes['mutateWorkoutResponse'] | ResolversTypes['mutateWorkoutsResponse'] | ResolversTypes['presetResponse'];
  Notification: ResolverTypeWrapper<Notificationmodel>;
  NotificationResponse: ResolverTypeWrapper<NotificationResponse>;
  PresetDifficulty: PresetDifficulty;
  PresetExcerciseSet: ResolverTypeWrapper<PresetExcerciseSetmodel>;
  PresetExcerciseSetGroup: ResolverTypeWrapper<PresetExcerciseSetGroupmodel>;
  PresetExcerciseSetGroupInput: PresetExcerciseSetGroupInput;
  PresetExcerciseSetInput: PresetExcerciseSetInput;
  PresetWorkoutInput: PresetWorkoutInput;
  PresetWorkouts: ResolverTypeWrapper<PresetWorkoutsmodel>;
  PrivateMessage: ResolverTypeWrapper<PrivateMessage>;
  Program: ResolverTypeWrapper<Programmodel>;
  ProgramPreset: ResolverTypeWrapper<ProgramPresetmodel>;
  ProgramType: ProgramType;
  Query: ResolverTypeWrapper<{}>;
  Review: ResolverTypeWrapper<Review>;
  SignupResponse: ResolverTypeWrapper<SignupResponse>;
  String: ResolverTypeWrapper<Scalars['String']>;
  Token: ResolverTypeWrapper<Tokenmodel>;
  User: ResolverTypeWrapper<Usermodel>;
  UserQueryCoachFilter: UserQueryCoachFilter;
  WeightUnit: WeightUnit;
  Workout: ResolverTypeWrapper<Workoutmodel>;
  WorkoutAverageRPEDataPoint: ResolverTypeWrapper<WorkoutAverageRpeDataPoint>;
  WorkoutFilter: WorkoutFilter;
  WorkoutFrequency: ResolverTypeWrapper<WorkoutFrequency>;
  WorkoutQueryFilter: WorkoutQueryFilter;
  WorkoutState: WorkoutState;
  coachUserFilter: CoachUserFilter;
  excerciseMetaDataInput: ExcerciseMetaDataInput;
  excerciseSetGroupInput: ExcerciseSetGroupInput;
  excerciseSetInput: ExcerciseSetInput;
  mutateCoachClientRelationship: ResolverTypeWrapper<Omit<MutateCoachClientRelationship, 'client_coach_relationship'> & { client_coach_relationship?: Maybe<ResolversTypes['CoachClientRelationship']> }>;
  mutateExcerciseMetaDataResponse: ResolverTypeWrapper<Omit<MutateExcerciseMetaDataResponse, 'excercise_metadata'> & { excercise_metadata?: Maybe<ResolversTypes['ExcerciseMetadata']> }>;
  mutateMeasurementResponse: ResolverTypeWrapper<Omit<MutateMeasurementResponse, 'measurement'> & { measurement?: Maybe<ResolversTypes['Measurement']> }>;
  mutateMuscleRegionResponse: ResolverTypeWrapper<Omit<MutateMuscleRegionResponse, 'muscle_region'> & { muscle_region?: Maybe<ResolversTypes['MuscleRegion']> }>;
  mutateProgramResponse: ResolverTypeWrapper<Omit<MutateProgramResponse, 'program'> & { program?: Maybe<ResolversTypes['Program']> }>;
  mutateWorkoutResponse: ResolverTypeWrapper<Omit<MutateWorkoutResponse, 'workout'> & { workout?: Maybe<ResolversTypes['Workout']> }>;
  mutateWorkoutsResponse: ResolverTypeWrapper<Omit<MutateWorkoutsResponse, 'workouts'> & { workouts?: Maybe<Array<ResolversTypes['Workout']>> }>;
  presetResponse: ResolverTypeWrapper<PresetResponse>;
  programQueryFilter: ProgramQueryFilter;
  workoutInput: WorkoutInput;
};

/** Mapping between all available schema types and the resolvers parents */
export type ResolversParentTypes = {
  BaseUser: BaseUsermodel;
  Boolean: Scalars['Boolean'];
  BroadCast: BroadCastmodel;
  Coach: Coachmodel;
  CoachClientRelationship: CoachClientRelationshipmodel;
  ContentBlock: ContentBlockmodel;
  Date: Scalars['Date'];
  Excercise: Excercisemodel;
  ExcerciseInput: ExcerciseInput;
  ExcerciseMetadata: ExcerciseMetadatamodel;
  ExcercisePerformance: Omit<ExcercisePerformance, 'grouped_excercise_sets'> & { grouped_excercise_sets?: Maybe<Array<ResolversParentTypes['GroupedExcerciseSets']>> };
  ExcerciseSet: ExcerciseSetmodel;
  ExcerciseSetGroup: ExcerciseSetGroupmodel;
  ExerciseOneRepMaxDataPoint: ExerciseOneRepMaxDataPoint;
  ExerciseTotalVolumeDataPoint: ExerciseTotalVolumeDataPoint;
  FCMToken: FcmToken;
  Float: Scalars['Float'];
  GenerateIdTokenResponse: Omit<GenerateIdTokenResponse, 'token'> & { token?: Maybe<ResolversParentTypes['Token']> };
  GroupedExcerciseSets: Omit<GroupedExcerciseSets, 'excercise_sets'> & { excercise_sets?: Maybe<Array<ResolversParentTypes['ExcerciseSet']>> };
  ID: Scalars['ID'];
  Int: Scalars['Int'];
  Measurement: Measurementmodel;
  MuscleRegion: MuscleRegionmodel;
  MutateBaseUserResponse: Omit<MutateBaseUserResponse, 'user'> & { user?: Maybe<ResolversParentTypes['BaseUser']> };
  MutatePrivateMessageResponse: MutatePrivateMessageResponse;
  MutateUserResponse: Omit<MutateUserResponse, 'user'> & { user?: Maybe<ResolversParentTypes['User']> };
  Mutation: {};
  MutationResponse: ResolversParentTypes['GenerateIdTokenResponse'] | ResolversParentTypes['MutateBaseUserResponse'] | ResolversParentTypes['MutatePrivateMessageResponse'] | ResolversParentTypes['MutateUserResponse'] | ResolversParentTypes['NotificationResponse'] | ResolversParentTypes['SignupResponse'] | ResolversParentTypes['mutateCoachClientRelationship'] | ResolversParentTypes['mutateExcerciseMetaDataResponse'] | ResolversParentTypes['mutateMeasurementResponse'] | ResolversParentTypes['mutateMuscleRegionResponse'] | ResolversParentTypes['mutateProgramResponse'] | ResolversParentTypes['mutateWorkoutResponse'] | ResolversParentTypes['mutateWorkoutsResponse'] | ResolversParentTypes['presetResponse'];
  Notification: Notificationmodel;
  NotificationResponse: NotificationResponse;
  PresetExcerciseSet: PresetExcerciseSetmodel;
  PresetExcerciseSetGroup: PresetExcerciseSetGroupmodel;
  PresetExcerciseSetGroupInput: PresetExcerciseSetGroupInput;
  PresetExcerciseSetInput: PresetExcerciseSetInput;
  PresetWorkoutInput: PresetWorkoutInput;
  PresetWorkouts: PresetWorkoutsmodel;
  PrivateMessage: PrivateMessage;
  Program: Programmodel;
  ProgramPreset: ProgramPresetmodel;
  Query: {};
  Review: Review;
  SignupResponse: SignupResponse;
  String: Scalars['String'];
  Token: Tokenmodel;
  User: Usermodel;
  UserQueryCoachFilter: UserQueryCoachFilter;
  Workout: Workoutmodel;
  WorkoutAverageRPEDataPoint: WorkoutAverageRpeDataPoint;
  WorkoutFrequency: WorkoutFrequency;
  WorkoutQueryFilter: WorkoutQueryFilter;
  excerciseMetaDataInput: ExcerciseMetaDataInput;
  excerciseSetGroupInput: ExcerciseSetGroupInput;
  excerciseSetInput: ExcerciseSetInput;
  mutateCoachClientRelationship: Omit<MutateCoachClientRelationship, 'client_coach_relationship'> & { client_coach_relationship?: Maybe<ResolversParentTypes['CoachClientRelationship']> };
  mutateExcerciseMetaDataResponse: Omit<MutateExcerciseMetaDataResponse, 'excercise_metadata'> & { excercise_metadata?: Maybe<ResolversParentTypes['ExcerciseMetadata']> };
  mutateMeasurementResponse: Omit<MutateMeasurementResponse, 'measurement'> & { measurement?: Maybe<ResolversParentTypes['Measurement']> };
  mutateMuscleRegionResponse: Omit<MutateMuscleRegionResponse, 'muscle_region'> & { muscle_region?: Maybe<ResolversParentTypes['MuscleRegion']> };
  mutateProgramResponse: Omit<MutateProgramResponse, 'program'> & { program?: Maybe<ResolversParentTypes['Program']> };
  mutateWorkoutResponse: Omit<MutateWorkoutResponse, 'workout'> & { workout?: Maybe<ResolversParentTypes['Workout']> };
  mutateWorkoutsResponse: Omit<MutateWorkoutsResponse, 'workouts'> & { workouts?: Maybe<Array<ResolversParentTypes['Workout']>> };
  presetResponse: PresetResponse;
  programQueryFilter: ProgramQueryFilter;
  workoutInput: WorkoutInput;
};

export type BaseUserResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['BaseUser'] = ResolversParentTypes['BaseUser']> = {
  base_user_id?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  coach?: Resolver<Maybe<ResolversTypes['Coach']>, ParentType, ContextType>;
  displayName?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  email?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  fcm_tokens?: Resolver<Array<ResolversTypes['FCMToken']>, ParentType, ContextType>;
  firebase_uid?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  user?: Resolver<Maybe<ResolversTypes['User']>, ParentType, ContextType>;
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
  Program?: Resolver<Maybe<Array<ResolversTypes['Program']>>, ParentType, ContextType>;
  Review?: Resolver<Maybe<Array<ResolversTypes['Review']>>, ParentType, ContextType>;
  coach_id?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type CoachClientRelationshipResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['CoachClientRelationship'] = ResolversParentTypes['CoachClientRelationship']> = {
  active?: Resolver<Maybe<ResolversTypes['Boolean']>, ParentType, ContextType>;
  coach?: Resolver<Maybe<ResolversTypes['Coach']>, ParentType, ContextType>;
  date_created?: Resolver<Maybe<ResolversTypes['Date']>, ParentType, ContextType>;
  user?: Resolver<Maybe<ResolversTypes['User']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type ContentBlockResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['ContentBlock'] = ResolversParentTypes['ContentBlock']> = {
  content_block_id?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  content_block_type?: Resolver<ResolversTypes['ContentBlockType'], ParentType, ContextType>;
  description?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  title?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  video_url?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export interface DateScalarConfig extends GraphQLScalarTypeConfig<ResolversTypes['Date'], any> {
  name: 'Date';
}

export type ExcerciseResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['Excercise'] = ResolversParentTypes['Excercise']> = {
  assisted?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
  body_weight?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
  dynamic_stabilizer_muscles?: Resolver<Array<ResolversTypes['MuscleRegion']>, ParentType, ContextType>;
  equipment_required?: Resolver<Array<ResolversTypes['Equipment']>, ParentType, ContextType>;
  excercise_force?: Resolver<Array<ResolversTypes['String']>, ParentType, ContextType>;
  excercise_instructions?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  excercise_mechanics?: Resolver<Array<ResolversTypes['ExcerciseMechanics']>, ParentType, ContextType>;
  excercise_metadata?: Resolver<Maybe<ResolversTypes['ExcerciseMetadata']>, ParentType, ContextType>;
  excercise_name?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  excercise_preparation?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  excercise_tips?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  excercise_utility?: Resolver<Array<ResolversTypes['ExcerciseUtility']>, ParentType, ContextType>;
  stabilizer_muscles?: Resolver<Array<ResolversTypes['MuscleRegion']>, ParentType, ContextType>;
  synergist_muscles?: Resolver<Array<ResolversTypes['MuscleRegion']>, ParentType, ContextType>;
  target_regions?: Resolver<Array<ResolversTypes['MuscleRegion']>, ParentType, ContextType>;
  video_url?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type ExcerciseMetadataResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['ExcerciseMetadata'] = ResolversParentTypes['ExcerciseMetadata']> = {
  best_rep?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  best_weight?: Resolver<Maybe<ResolversTypes['Float']>, ParentType, ContextType>;
  current_duration?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  estimated_historical_average_best_rep?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  estimated_historical_best_one_rep_max?: Resolver<Maybe<ResolversTypes['Float']>, ParentType, ContextType>;
  excercise_metadata_state?: Resolver<ResolversTypes['ExcerciseMetadataState'], ParentType, ContextType>;
  excercise_name?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  last_excecuted?: Resolver<Maybe<ResolversTypes['Date']>, ParentType, ContextType>;
  preferred?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
  rest_time_lower_bound?: Resolver<ResolversTypes['Int'], ParentType, ContextType>;
  rest_time_upper_bound?: Resolver<ResolversTypes['Int'], ParentType, ContextType>;
  user_id?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
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
  target_reps?: Resolver<ResolversTypes['Int'], ParentType, ContextType>;
  target_weight?: Resolver<ResolversTypes['Float'], ParentType, ContextType>;
  to_skip?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type ExcerciseSetGroupResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['ExcerciseSetGroup'] = ResolversParentTypes['ExcerciseSetGroup']> = {
  excercise?: Resolver<ResolversTypes['Excercise'], ParentType, ContextType>;
  excercise_metadata?: Resolver<ResolversTypes['ExcerciseMetadata'], ParentType, ContextType>;
  excercise_name?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  excercise_set_group_id?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  excercise_set_group_state?: Resolver<ResolversTypes['ExcerciseSetGroupState'], ParentType, ContextType>;
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
  date_issued?: Resolver<ResolversTypes['Date'], ParentType, ContextType>;
  token?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
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

export type MutatePrivateMessageResponseResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['MutatePrivateMessageResponse'] = ResolversParentTypes['MutatePrivateMessageResponse']> = {
  code?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  message?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  privateMessage?: Resolver<Maybe<ResolversTypes['PrivateMessage']>, ParentType, ContextType>;
  success?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
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
  completeWorkout?: Resolver<Maybe<ResolversTypes['mutateWorkoutResponse']>, ParentType, ContextType, RequireFields<MutationCompleteWorkoutArgs, 'excercise_set_groups' | 'workout_id'>>;
  createCoachClientRelationship?: Resolver<Maybe<ResolversTypes['mutateCoachClientRelationship']>, ParentType, ContextType, Partial<MutationCreateCoachClientRelationshipArgs>>;
  createExcerciseMetadata?: Resolver<Maybe<ResolversTypes['mutateExcerciseMetaDataResponse']>, ParentType, ContextType, RequireFields<MutationCreateExcerciseMetadataArgs, 'excercise_name' | 'user_id'>>;
  createMeasurement?: Resolver<Maybe<ResolversTypes['mutateMeasurementResponse']>, ParentType, ContextType, RequireFields<MutationCreateMeasurementArgs, 'length_units' | 'measured_at' | 'measurement_value' | 'muscle_region_id'>>;
  createMuscleRegion?: Resolver<Maybe<ResolversTypes['mutateMuscleRegionResponse']>, ParentType, ContextType, RequireFields<MutationCreateMuscleRegionArgs, 'muscle_region_description' | 'muscle_region_name' | 'muscle_region_type'>>;
  createPrivateMessage?: Resolver<Maybe<ResolversTypes['MutatePrivateMessageResponse']>, ParentType, ContextType, RequireFields<MutationCreatePrivateMessageArgs, 'message_content' | 'receiver_id'>>;
  createProgram?: Resolver<ResolversTypes['mutateProgramResponse'], ParentType, ContextType, RequireFields<MutationCreateProgramArgs, 'program_type' | 'workoutsInput'>>;
  createProgramPreset?: Resolver<Maybe<ResolversTypes['presetResponse']>, ParentType, ContextType, RequireFields<MutationCreateProgramPresetArgs, 'preset_difficulty' | 'preset_name' | 'preset_workouts'>>;
  createWorkout?: Resolver<Maybe<ResolversTypes['mutateWorkoutResponse']>, ParentType, ContextType, RequireFields<MutationCreateWorkoutArgs, 'date_scheduled' | 'excercise_set_groups' | 'program_id' | 'user_id' | 'workout_name'>>;
  deleteCoachClientRelationship?: Resolver<Maybe<ResolversTypes['mutateCoachClientRelationship']>, ParentType, ContextType, Partial<MutationDeleteCoachClientRelationshipArgs>>;
  deleteMeasurement?: Resolver<Maybe<ResolversTypes['mutateMeasurementResponse']>, ParentType, ContextType, RequireFields<MutationDeleteMeasurementArgs, 'measurement_id'>>;
  deleteMuscleRegion?: Resolver<Maybe<ResolversTypes['mutateMuscleRegionResponse']>, ParentType, ContextType, RequireFields<MutationDeleteMuscleRegionArgs, 'muscle_region_id'>>;
  deletePrivateMessage?: Resolver<Maybe<ResolversTypes['MutationResponse']>, ParentType, ContextType, RequireFields<MutationDeletePrivateMessageArgs, 'message_id'>>;
  deleteProgram?: Resolver<ResolversTypes['mutateProgramResponse'], ParentType, ContextType, RequireFields<MutationDeleteProgramArgs, 'program_id'>>;
  deleteProgramPreset?: Resolver<Maybe<ResolversTypes['presetResponse']>, ParentType, ContextType, RequireFields<MutationDeleteProgramPresetArgs, 'programPreset_id'>>;
  deleteWorkout?: Resolver<Maybe<ResolversTypes['mutateWorkoutResponse']>, ParentType, ContextType, RequireFields<MutationDeleteWorkoutArgs, 'workout_id'>>;
  endActiveProgram?: Resolver<ResolversTypes['mutateProgramResponse'], ParentType, ContextType, RequireFields<MutationEndActiveProgramArgs, 'user_id'>>;
  generateFirebaseIdToken?: Resolver<Maybe<ResolversTypes['GenerateIdTokenResponse']>, ParentType, ContextType, RequireFields<MutationGenerateFirebaseIdTokenArgs, 'uid'>>;
  generateNotification?: Resolver<Maybe<ResolversTypes['NotificationResponse']>, ParentType, ContextType, RequireFields<MutationGenerateNotificationArgs, 'body' | 'title' | 'token'>>;
  generateProgram?: Resolver<ResolversTypes['Program'], ParentType, ContextType, RequireFields<MutationGenerateProgramArgs, 'initial_days'>>;
  generateWorkoutReminder?: Resolver<Maybe<ResolversTypes['NotificationResponse']>, ParentType, ContextType>;
  refreshProgram?: Resolver<ResolversTypes['Program'], ParentType, ContextType, RequireFields<MutationRefreshProgramArgs, 'program_id'>>;
  signup?: Resolver<Maybe<ResolversTypes['SignupResponse']>, ParentType, ContextType, RequireFields<MutationSignupArgs, 'displayName' | 'email' | 'is_user' | 'password'>>;
  updateBaseUser?: Resolver<Maybe<ResolversTypes['MutateBaseUserResponse']>, ParentType, ContextType, Partial<MutationUpdateBaseUserArgs>>;
  updateCoachClientRelationship?: Resolver<Maybe<ResolversTypes['mutateCoachClientRelationship']>, ParentType, ContextType, RequireFields<MutationUpdateCoachClientRelationshipArgs, 'active'>>;
  updateExcerciseMetadata?: Resolver<Maybe<ResolversTypes['mutateExcerciseMetaDataResponse']>, ParentType, ContextType, RequireFields<MutationUpdateExcerciseMetadataArgs, 'excercise_metadata_state' | 'excercise_name'>>;
  updateMeasurement?: Resolver<Maybe<ResolversTypes['mutateMeasurementResponse']>, ParentType, ContextType, RequireFields<MutationUpdateMeasurementArgs, 'measurement_id'>>;
  updateMuscleRegion?: Resolver<Maybe<ResolversTypes['mutateMuscleRegionResponse']>, ParentType, ContextType, RequireFields<MutationUpdateMuscleRegionArgs, 'muscle_region_id'>>;
  updateProgram?: Resolver<ResolversTypes['mutateProgramResponse'], ParentType, ContextType, RequireFields<MutationUpdateProgramArgs, 'program_id'>>;
  updateUser?: Resolver<Maybe<ResolversTypes['MutateUserResponse']>, ParentType, ContextType, Partial<MutationUpdateUserArgs>>;
  updateWorkout?: Resolver<Maybe<ResolversTypes['mutateWorkoutResponse']>, ParentType, ContextType, RequireFields<MutationUpdateWorkoutArgs, 'workout_id'>>;
};

export type MutationResponseResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['MutationResponse'] = ResolversParentTypes['MutationResponse']> = {
  __resolveType: TypeResolveFn<'GenerateIdTokenResponse' | 'MutateBaseUserResponse' | 'MutatePrivateMessageResponse' | 'MutateUserResponse' | 'NotificationResponse' | 'SignupResponse' | 'mutateCoachClientRelationship' | 'mutateExcerciseMetaDataResponse' | 'mutateMeasurementResponse' | 'mutateMuscleRegionResponse' | 'mutateProgramResponse' | 'mutateWorkoutResponse' | 'mutateWorkoutsResponse' | 'presetResponse', ParentType, ContextType>;
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

export type PresetExcerciseSetResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['PresetExcerciseSet'] = ResolversParentTypes['PresetExcerciseSet']> = {
  preset_excercise_set_group_id?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  preset_excercise_set_id?: Resolver<ResolversTypes['Int'], ParentType, ContextType>;
  target_reps?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  target_weight?: Resolver<Maybe<ResolversTypes['Float']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type PresetExcerciseSetGroupResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['PresetExcerciseSetGroup'] = ResolversParentTypes['PresetExcerciseSetGroup']> = {
  excercise_name?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  preset_excercise_set_group_id?: Resolver<ResolversTypes['Int'], ParentType, ContextType>;
  preset_excercise_sets?: Resolver<Array<ResolversTypes['PresetExcerciseSet']>, ParentType, ContextType>;
  preset_workout_id?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type PresetWorkoutsResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['PresetWorkouts'] = ResolversParentTypes['PresetWorkouts']> = {
  preset_excercise_set_groups?: Resolver<Array<ResolversTypes['PresetExcerciseSetGroup']>, ParentType, ContextType>;
  preset_workout_id?: Resolver<ResolversTypes['Int'], ParentType, ContextType>;
  program_preset_id?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  rest_day?: Resolver<Maybe<ResolversTypes['Boolean']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type PrivateMessageResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['PrivateMessage'] = ResolversParentTypes['PrivateMessage']> = {
  date_issued?: Resolver<Maybe<ResolversTypes['Date']>, ParentType, ContextType>;
  message_content?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  message_id?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  receiver_id?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  sender_id?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type ProgramResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['Program'] = ResolversParentTypes['Program']> = {
  coach?: Resolver<Maybe<ResolversTypes['Coach']>, ParentType, ContextType>;
  ending_date?: Resolver<Maybe<ResolversTypes['Date']>, ParentType, ContextType>;
  is_active?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
  program_id?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  program_type?: Resolver<ResolversTypes['ProgramType'], ParentType, ContextType>;
  starting_date?: Resolver<ResolversTypes['Date'], ParentType, ContextType>;
  user?: Resolver<ResolversTypes['User'], ParentType, ContextType>;
  workouts?: Resolver<Array<ResolversTypes['Workout']>, ParentType, ContextType, Partial<ProgramWorkoutsArgs>>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type ProgramPresetResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['ProgramPreset'] = ResolversParentTypes['ProgramPreset']> = {
  coach_id?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  image_url?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  preset_difficulty?: Resolver<Maybe<ResolversTypes['PresetDifficulty']>, ParentType, ContextType>;
  preset_name?: Resolver<Maybe<ResolversTypes['String']>, ParentType, ContextType>;
  preset_workouts?: Resolver<Array<ResolversTypes['PresetWorkouts']>, ParentType, ContextType>;
  programPreset_id?: Resolver<ResolversTypes['Int'], ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type QueryResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['Query'] = ResolversParentTypes['Query']> = {
  analyticsExerciseOneRepMax?: Resolver<Array<ResolversTypes['ExerciseOneRepMaxDataPoint']>, ParentType, ContextType, RequireFields<QueryAnalyticsExerciseOneRepMaxArgs, 'excercise_names_list'>>;
  analyticsExerciseTotalVolume?: Resolver<Array<ResolversTypes['ExerciseTotalVolumeDataPoint']>, ParentType, ContextType, RequireFields<QueryAnalyticsExerciseTotalVolumeArgs, 'excercise_names_list'>>;
  analyticsWorkoutAverageRPE?: Resolver<Array<ResolversTypes['WorkoutAverageRPEDataPoint']>, ParentType, ContextType>;
  baseUser?: Resolver<ResolversTypes['BaseUser'], ParentType, ContextType>;
  excercises?: Resolver<Array<ResolversTypes['Excercise']>, ParentType, ContextType>;
  excludedExcercises?: Resolver<Array<ResolversTypes['Excercise']>, ParentType, ContextType>;
  getCoachClientRelationship?: Resolver<ResolversTypes['CoachClientRelationship'], ParentType, ContextType, Partial<QueryGetCoachClientRelationshipArgs>>;
  getCoachClientRelationships?: Resolver<Array<ResolversTypes['CoachClientRelationship']>, ParentType, ContextType>;
  getContentBlocks?: Resolver<Array<ResolversTypes['ContentBlock']>, ParentType, ContextType, RequireFields<QueryGetContentBlocksArgs, 'content_block_type'>>;
  getExcercise?: Resolver<ResolversTypes['Excercise'], ParentType, ContextType, RequireFields<QueryGetExcerciseArgs, 'excercise_name'>>;
  getExcerciseMetadatas?: Resolver<Array<ResolversTypes['ExcerciseMetadata']>, ParentType, ContextType, RequireFields<QueryGetExcerciseMetadatasArgs, 'excercise_names_list'>>;
  getExcercisePerformance?: Resolver<ResolversTypes['ExcercisePerformance'], ParentType, ContextType, RequireFields<QueryGetExcercisePerformanceArgs, 'excercise_name'>>;
  getPrivateMessages?: Resolver<Array<ResolversTypes['PrivateMessage']>, ParentType, ContextType, RequireFields<QueryGetPrivateMessagesArgs, 'pair_id'>>;
  notifications?: Resolver<Array<ResolversTypes['Notification']>, ParentType, ContextType>;
  preset?: Resolver<ResolversTypes['ProgramPreset'], ParentType, ContextType, RequireFields<QueryPresetArgs, 'programPreset_id'>>;
  presets?: Resolver<Array<ResolversTypes['ProgramPreset']>, ParentType, ContextType>;
  previousWorkout?: Resolver<Maybe<ResolversTypes['Workout']>, ParentType, ContextType, RequireFields<QueryPreviousWorkoutArgs, 'program_id' | 'workout_name'>>;
  program?: Resolver<ResolversTypes['Program'], ParentType, ContextType, Partial<QueryProgramArgs>>;
  programs?: Resolver<Array<ResolversTypes['Program']>, ParentType, ContextType, Partial<QueryProgramsArgs>>;
  user?: Resolver<ResolversTypes['User'], ParentType, ContextType>;
  users?: Resolver<Array<ResolversTypes['User']>, ParentType, ContextType, Partial<QueryUsersArgs>>;
  workout?: Resolver<ResolversTypes['Workout'], ParentType, ContextType, RequireFields<QueryWorkoutArgs, 'previous' | 'user_id' | 'workout_id'>>;
  workout_frequencies?: Resolver<Array<ResolversTypes['WorkoutFrequency']>, ParentType, ContextType>;
  workouts?: Resolver<Array<ResolversTypes['Workout']>, ParentType, ContextType, RequireFields<QueryWorkoutsArgs, 'filter'>>;
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
  base_user?: Resolver<Maybe<ResolversTypes['BaseUser']>, ParentType, ContextType>;
  base_user_id?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  body_weight_rep_lower_bound?: Resolver<ResolversTypes['Int'], ParentType, ContextType>;
  body_weight_rep_upper_bound?: Resolver<ResolversTypes['Int'], ParentType, ContextType>;
  broadcasts?: Resolver<Array<ResolversTypes['BroadCast']>, ParentType, ContextType>;
  compound_movement_rep_lower_bound?: Resolver<ResolversTypes['Int'], ParentType, ContextType>;
  compound_movement_rep_upper_bound?: Resolver<ResolversTypes['Int'], ParentType, ContextType>;
  current_program_enrollment_id?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  dark_mode?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
  equipment_accessible?: Resolver<Array<ResolversTypes['Equipment']>, ParentType, ContextType>;
  excercise_metadata?: Resolver<Array<ResolversTypes['ExcerciseMetadata']>, ParentType, ContextType>;
  gender?: Resolver<ResolversTypes['Gender'], ParentType, ContextType>;
  goal?: Resolver<Maybe<ResolversTypes['Goal']>, ParentType, ContextType>;
  height?: Resolver<Maybe<ResolversTypes['Float']>, ParentType, ContextType>;
  height_unit?: Resolver<ResolversTypes['LengthUnit'], ParentType, ContextType>;
  isolated_movement_rep_lower_bound?: Resolver<ResolversTypes['Int'], ParentType, ContextType>;
  isolated_movement_rep_upper_bound?: Resolver<ResolversTypes['Int'], ParentType, ContextType>;
  level_of_experience?: Resolver<Maybe<ResolversTypes['LevelOfExperience']>, ParentType, ContextType>;
  measurements?: Resolver<Array<ResolversTypes['Measurement']>, ParentType, ContextType>;
  notifications?: Resolver<Array<ResolversTypes['Notification']>, ParentType, ContextType>;
  prior_years_of_experience?: Resolver<Maybe<ResolversTypes['Float']>, ParentType, ContextType>;
  program?: Resolver<Array<ResolversTypes['Program']>, ParentType, ContextType>;
  selected_exercise_for_analytics?: Resolver<Array<ResolversTypes['Excercise']>, ParentType, ContextType>;
  signup_date?: Resolver<ResolversTypes['Date'], ParentType, ContextType>;
  use_rpe?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
  user_id?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  weight?: Resolver<Maybe<ResolversTypes['Float']>, ParentType, ContextType>;
  weight_unit?: Resolver<ResolversTypes['WeightUnit'], ParentType, ContextType>;
  workout_duration?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  workout_frequency?: Resolver<Maybe<ResolversTypes['Int']>, ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type WorkoutResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['Workout'] = ResolversParentTypes['Workout']> = {
  date_closed?: Resolver<Maybe<ResolversTypes['Date']>, ParentType, ContextType>;
  date_scheduled?: Resolver<ResolversTypes['Date'], ParentType, ContextType>;
  excercise_set_groups?: Resolver<Array<ResolversTypes['ExcerciseSetGroup']>, ParentType, ContextType>;
  last_completed?: Resolver<Maybe<ResolversTypes['Date']>, ParentType, ContextType>;
  performance_rating?: Resolver<Maybe<ResolversTypes['Float']>, ParentType, ContextType>;
  program?: Resolver<Maybe<ResolversTypes['Program']>, ParentType, ContextType>;
  programProgram_id?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  workout_id?: Resolver<ResolversTypes['ID'], ParentType, ContextType>;
  workout_name?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  workout_state?: Resolver<Maybe<ResolversTypes['WorkoutState']>, ParentType, ContextType>;
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

export type MutateCoachClientRelationshipResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['mutateCoachClientRelationship'] = ResolversParentTypes['mutateCoachClientRelationship']> = {
  client_coach_relationship?: Resolver<Maybe<ResolversTypes['CoachClientRelationship']>, ParentType, ContextType>;
  code?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  message?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  success?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
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

export type PresetResponseResolvers<ContextType = AppContext, ParentType extends ResolversParentTypes['presetResponse'] = ResolversParentTypes['presetResponse']> = {
  code?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  message?: Resolver<ResolversTypes['String'], ParentType, ContextType>;
  success?: Resolver<ResolversTypes['Boolean'], ParentType, ContextType>;
  __isTypeOf?: IsTypeOfResolverFn<ParentType, ContextType>;
};

export type Resolvers<ContextType = AppContext> = {
  BaseUser?: BaseUserResolvers<ContextType>;
  BroadCast?: BroadCastResolvers<ContextType>;
  Coach?: CoachResolvers<ContextType>;
  CoachClientRelationship?: CoachClientRelationshipResolvers<ContextType>;
  ContentBlock?: ContentBlockResolvers<ContextType>;
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
  MutatePrivateMessageResponse?: MutatePrivateMessageResponseResolvers<ContextType>;
  MutateUserResponse?: MutateUserResponseResolvers<ContextType>;
  Mutation?: MutationResolvers<ContextType>;
  MutationResponse?: MutationResponseResolvers<ContextType>;
  Notification?: NotificationResolvers<ContextType>;
  NotificationResponse?: NotificationResponseResolvers<ContextType>;
  PresetExcerciseSet?: PresetExcerciseSetResolvers<ContextType>;
  PresetExcerciseSetGroup?: PresetExcerciseSetGroupResolvers<ContextType>;
  PresetWorkouts?: PresetWorkoutsResolvers<ContextType>;
  PrivateMessage?: PrivateMessageResolvers<ContextType>;
  Program?: ProgramResolvers<ContextType>;
  ProgramPreset?: ProgramPresetResolvers<ContextType>;
  Query?: QueryResolvers<ContextType>;
  Review?: ReviewResolvers<ContextType>;
  SignupResponse?: SignupResponseResolvers<ContextType>;
  Token?: TokenResolvers<ContextType>;
  User?: UserResolvers<ContextType>;
  Workout?: WorkoutResolvers<ContextType>;
  WorkoutAverageRPEDataPoint?: WorkoutAverageRpeDataPointResolvers<ContextType>;
  WorkoutFrequency?: WorkoutFrequencyResolvers<ContextType>;
  mutateCoachClientRelationship?: MutateCoachClientRelationshipResolvers<ContextType>;
  mutateExcerciseMetaDataResponse?: MutateExcerciseMetaDataResponseResolvers<ContextType>;
  mutateMeasurementResponse?: MutateMeasurementResponseResolvers<ContextType>;
  mutateMuscleRegionResponse?: MutateMuscleRegionResponseResolvers<ContextType>;
  mutateProgramResponse?: MutateProgramResponseResolvers<ContextType>;
  mutateWorkoutResponse?: MutateWorkoutResponseResolvers<ContextType>;
  mutateWorkoutsResponse?: MutateWorkoutsResponseResolvers<ContextType>;
  presetResponse?: PresetResponseResolvers<ContextType>;
};

