"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.WorkoutState = exports.WorkoutFilter = exports.WeightUnit = exports.MuscleRegionType = exports.LevelOfExperience = exports.LengthUnit = exports.Goal = exports.Gender = exports.FailureReason = exports.ExcerciseSetGroupState = exports.ExcerciseMetadataState = exports.Equipment = void 0;
var Equipment;
(function (Equipment) {
    Equipment["Barbell"] = "BARBELL";
    Equipment["Bench"] = "BENCH";
    Equipment["Cable"] = "CABLE";
    Equipment["Dumbbell"] = "DUMBBELL";
    Equipment["Kettlebell"] = "KETTLEBELL";
    Equipment["Lever"] = "LEVER";
    Equipment["MedicineBall"] = "MEDICINE_BALL";
    Equipment["ParallelBars"] = "PARALLEL_BARS";
    Equipment["Preacher"] = "PREACHER";
    Equipment["PullUpBar"] = "PULL_UP_BAR";
    Equipment["Sled"] = "SLED";
    Equipment["Smith"] = "SMITH";
    Equipment["StabilityBall"] = "STABILITY_BALL";
    Equipment["Suspension"] = "SUSPENSION";
    Equipment["TrapBar"] = "TRAP_BAR";
    Equipment["TBar"] = "T_BAR";
})(Equipment = exports.Equipment || (exports.Equipment = {}));
var ExcerciseMetadataState;
(function (ExcerciseMetadataState) {
    ExcerciseMetadataState["DecreasedDifficulty"] = "DECREASED_DIFFICULTY";
    ExcerciseMetadataState["IncreasedDifficulty"] = "INCREASED_DIFFICULTY";
    ExcerciseMetadataState["Learning"] = "LEARNING";
    ExcerciseMetadataState["Maintainence"] = "MAINTAINENCE";
})(ExcerciseMetadataState = exports.ExcerciseMetadataState || (exports.ExcerciseMetadataState = {}));
var ExcerciseSetGroupState;
(function (ExcerciseSetGroupState) {
    ExcerciseSetGroupState["DeletedPermanantly"] = "DELETED_PERMANANTLY";
    ExcerciseSetGroupState["DeletedTemporarily"] = "DELETED_TEMPORARILY";
    ExcerciseSetGroupState["NormalOperation"] = "NORMAL_OPERATION";
    ExcerciseSetGroupState["ReplacementPermanantly"] = "REPLACEMENT_PERMANANTLY";
    ExcerciseSetGroupState["ReplacementTemporarily"] = "REPLACEMENT_TEMPORARILY";
})(ExcerciseSetGroupState = exports.ExcerciseSetGroupState || (exports.ExcerciseSetGroupState = {}));
var FailureReason;
(function (FailureReason) {
    FailureReason["InsufficientRestTime"] = "INSUFFICIENT_REST_TIME";
    FailureReason["InsufficientSleep"] = "INSUFFICIENT_SLEEP";
    FailureReason["InsufficientTime"] = "INSUFFICIENT_TIME";
    FailureReason["LowMood"] = "LOW_MOOD";
    FailureReason["TooDifficult"] = "TOO_DIFFICULT";
})(FailureReason = exports.FailureReason || (exports.FailureReason = {}));
/** Gender type. */
var Gender;
(function (Gender) {
    Gender["Female"] = "FEMALE";
    Gender["Male"] = "MALE";
    Gender["RatherNotSay"] = "RATHER_NOT_SAY";
})(Gender = exports.Gender || (exports.Gender = {}));
var Goal;
(function (Goal) {
    Goal["Athleticism"] = "ATHLETICISM";
    Goal["BodyRecomposition"] = "BODY_RECOMPOSITION";
    Goal["KeepingFit"] = "KEEPING_FIT";
    Goal["Others"] = "OTHERS";
    Goal["Strength"] = "STRENGTH";
})(Goal = exports.Goal || (exports.Goal = {}));
/** Units for length. */
var LengthUnit;
(function (LengthUnit) {
    LengthUnit["Cm"] = "CM";
    LengthUnit["Ft"] = "FT";
    LengthUnit["Mm"] = "MM";
    LengthUnit["Mtr"] = "MTR";
})(LengthUnit = exports.LengthUnit || (exports.LengthUnit = {}));
var LevelOfExperience;
(function (LevelOfExperience) {
    LevelOfExperience["Advanced"] = "ADVANCED";
    LevelOfExperience["Beginner"] = "BEGINNER";
    LevelOfExperience["Expert"] = "EXPERT";
    LevelOfExperience["Mid"] = "MID";
})(LevelOfExperience = exports.LevelOfExperience || (exports.LevelOfExperience = {}));
var MuscleRegionType;
(function (MuscleRegionType) {
    MuscleRegionType["Back"] = "BACK";
    MuscleRegionType["Calves"] = "CALVES";
    MuscleRegionType["Chest"] = "CHEST";
    MuscleRegionType["ForeArm"] = "FORE_ARM";
    MuscleRegionType["Hips"] = "HIPS";
    MuscleRegionType["Neck"] = "NECK";
    MuscleRegionType["Shoulder"] = "SHOULDER";
    MuscleRegionType["Thighs"] = "THIGHS";
    MuscleRegionType["UpperArm"] = "UPPER_ARM";
    MuscleRegionType["Waist"] = "WAIST";
})(MuscleRegionType = exports.MuscleRegionType || (exports.MuscleRegionType = {}));
/** Units for weight */
var WeightUnit;
(function (WeightUnit) {
    WeightUnit["Kg"] = "KG";
    WeightUnit["Lb"] = "LB";
})(WeightUnit = exports.WeightUnit || (exports.WeightUnit = {}));
/** Units for weight */
var WorkoutFilter;
(function (WorkoutFilter) {
    WorkoutFilter["Active"] = "ACTIVE";
    WorkoutFilter["Completed"] = "COMPLETED";
    WorkoutFilter["None"] = "NONE";
})(WorkoutFilter = exports.WorkoutFilter || (exports.WorkoutFilter = {}));
var WorkoutState;
(function (WorkoutState) {
    WorkoutState["Completed"] = "COMPLETED";
    WorkoutState["Draft"] = "DRAFT";
    WorkoutState["InProgress"] = "IN_PROGRESS";
    WorkoutState["Unattempted"] = "UNATTEMPTED";
})(WorkoutState = exports.WorkoutState || (exports.WorkoutState = {}));
//# sourceMappingURL=graphql.js.map