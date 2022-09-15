interface excerciseSetGroupInput {
  excercise_name: String;
  excercise_set_group_state: ExcerciseSetGroupState;
  excercise_metadata: excerciseMetaDataInput;
  excercise_sets: ExcerciseSet[];
  failure_reason: FailureReason;
}

const enum WeightUnit {
  KG,
  LB,
}

interface excerciseMetaDataInput {
  excercise_name: String;
  rest_time_lower_bound: Number;
  rest_time_upper_bound: Number;
  preferred: Boolean;
  haveRequiredEquipment: Boolean;
  excercise_metadata_state: String;
  last_excecuted: String;
  best_weight: Number;
  best_rep: Number;
  weight_unit: WeightUnit;
}

interface excerciseSetInput {
  target_weight: number;
  weight_unit: WeightUnit;
  target_reps: number;
  actual_weight: number;
  actual_reps: number;
}

interface rawExcerciseSetGroupsInput {
  excercise_name: String;
  excercise_set_group_state: ExcerciseSetGroupState;
  excercise_metadata?: excerciseMetaDataInput;
  excercise_sets: excerciseSetInput[];
  failure_reason: FailureReason;
}

const enum ExcerciseSetGroupState {
  DELETED_TEMPORARILY = "DELETED_TEMPORARILY",
  DELETED_PERMANANTLY = "DELETED_PERMANANTLY",
  REPLACEMENT_TEMPORARILY = "REPLACEMENT_TEMPORARILY",
  REPLACEMENT_PERMANANTLY = "REPLACEMENT_PERMANANTLY",
  NORMAL_OPERATION = "NORMAL_OPERATION",
}

enum FailureReason {
  INSUFFICIENT_TIME = "INSUFFICIENT_TIME",
  INSUFFICIENT_REST_TIME = "INSUFFICIENT_REST_TIME",
  TOO_DIFFICULT = "TOO_DIFFICULT",
  LOW_MOOD = "LOW_MOOD",
  INSUFFICIENT_SLEEP = "INSUFFICIENT_SLEEP",
}
