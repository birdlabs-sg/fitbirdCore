import gql from "graphql-tag";

export const Enum = gql`
  "Gender type."
  enum Gender {
    MALE
    FEMALE
    RATHER_NOT_SAY
  }

  "Units for weight"
  enum WeightUnit {
    KG
    LB
  }

  "Units for length."
  enum LengthUnit {
    CM
    MM
    MTR
    FT
  }

  enum WorkoutType {
    AI_MANAGED
    SELF_MANAGED
    COACH_MANAGED
  }

  "Used in overloading algorithm to determine what to do with that set."
  enum ExcerciseSetGroupState {
    DELETED_TEMPORARILY
    DELETED_PERMANANTLY
    REPLACEMENT_TEMPORARILY
    REPLACEMENT_PERMANANTLY
    NORMAL_OPERATION
  }

  enum WorkoutState {
    UNATTEMPTED
    IN_PROGRESS
    COMPLETED
    DRAFT
  }

  enum Equipment {
    DUMBBELL
    BARBELL
    KETTLEBELL
    CABLE
    LEVER
    SUSPENSION
    T_BAR
    TRAP_BAR
    SLED
    SMITH
    BENCH
    MEDICINE_BALL
    PREACHER
    PARALLEL_BARS
    PULL_UP_BAR
    STABILITY_BALL
  }

  enum MuscleRegionType {
    HIPS
    UPPER_ARM
    SHOULDER
    WAIST
    CALVES
    THIGHS
    BACK
    CHEST
    FORE_ARM
    NECK
  }

  enum ExcerciseMetadataState {
    LEARNING
    INCREASED_DIFFICULTY
    DECREASED_DIFFICULTY
    MAINTAINENCE
  }

  enum LevelOfExperience {
    BEGINNER
    MID
    ADVANCED
    EXPERT
  }

  enum Goal {
    BODY_RECOMPOSITION
    STRENGTH
    KEEPING_FIT
    ATHLETICISM
    OTHERS
  }

  "Units for weight"
  enum WorkoutFilter {
    ACTIVE
    COMPLETED
    NONE
  }

  enum FailureReason {
    INSUFFICIENT_TIME
    INSUFFICIENT_REST_TIME
    TOO_DIFFICULT
    LOW_MOOD
    INSUFFICIENT_SLEEP
  }
`;
