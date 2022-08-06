interface excerciseSetGroupInput {
  excercise_name: String;
  excercise_set_group_state: ExcerciseSetGroupState;
  excerciseMetadata: excerciseMetaDataInput;
  excercise_sets: ExcerciseSet[];
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
  target_weight: Number;
  weight_unit: WeightUnit;
  target_reps: Number;
  actual_weight: Number;
  actual_reps: Number;
}

interface rawExcerciseSetGroupsInput {
  excercise_name: String;
  excercise_set_group_state: ExcerciseSetGroupState;
  excercise_metadata?: excerciseMetaDataInput;
  excercise_sets: excerciseSetInput[];
}

const enum ExcerciseSetGroupState {
  DELETED_TEMPORARILY = "DELETED_TEMPORARILY",
  DELETED_PERMANANTLY = "DELETED_PERMANANTLY",
  REPLACEMENT_TEMPORARILY = "REPLACEMENT_TEMPORARILY",
  REPLACEMENT_PERMANANTLY = "REPLACEMENT_PERMANANTLY",
  NORMAL_OPERATION = "NORMAL_OPERATION",
}
