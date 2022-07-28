interface excerciseSetGroupInput {
  excercise_name: String;
  excercise_set_group_state: ExcerciseSetGroupState;
  excerciseMetadata: excerciseMetaDataInput;
  excercise_sets: ExcerciseSet[];
}

interface excerciseMetaDataInput {
  excercise_name: String;
  rest_time_lower_bound: number;
  rest_time_upper_bound: number;
  preferred: Boolean;
  haveRequiredEquipment: Boolean;
}

const enum ExcerciseSetGroupState {
  DELETED_TEMPORARILY = "DELETED_TEMPORARILY",
  DELETED_PERMANANTLY = "DELETED_PERMANANTLY",
  REPLACED_TEMPORARILY = "REPLACED_TEMPORARILY",
  REPLACED_PERMANANTLY = "REPLACED_PERMANANTLY",
  NORMAL_OPERATION = "NORMAL_OPERATION",
}
