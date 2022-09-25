"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.armDay = exports.legDay = exports.backAndArmDay = exports.chestAndArmDay = exports.lowerDay = exports.upperDay = exports.pushDay = exports.pullDay = exports.rotations_type = exports.workout_name_list = void 0;
const graphql_1 = require("../../../types/graphql");
const client_1 = require("@prisma/client");
/**
 * List that dictates what a generated workout would be
 */
exports.workout_name_list = Object.freeze([
    "Sexy Sparrow",
    "Odd Osprey",
    "Dangerous Dove",
    "Perky Pigeon",
    "Elated Eagle",
    "Kind King-fisher",
    "Seagull",
    "Ominous Owl",
    "Peaceful Parakeet",
    "Crazy Cuckoo",
    "Wacky Woodpecker",
    "Charming Canary",
]);
/**
 * List that dictates the rotation type that will be used in the workout generator
 */
exports.rotations_type = Object.freeze([
    [
        graphql_1.MuscleRegionType.Thighs,
        graphql_1.MuscleRegionType.Chest,
        graphql_1.MuscleRegionType.Back,
        graphql_1.MuscleRegionType.Shoulder,
        graphql_1.MuscleRegionType.UpperArm,
    ],
    [
        graphql_1.MuscleRegionType.Back,
        graphql_1.MuscleRegionType.Chest,
        graphql_1.MuscleRegionType.Shoulder,
        graphql_1.MuscleRegionType.Thighs,
        graphql_1.MuscleRegionType.UpperArm,
    ],
    [
        graphql_1.MuscleRegionType.Chest,
        graphql_1.MuscleRegionType.Back,
        graphql_1.MuscleRegionType.Shoulder,
        graphql_1.MuscleRegionType.Thighs,
        graphql_1.MuscleRegionType.UpperArm,
    ],
]);
//pending fix DO NOT TOUCH OR USE
exports.pullDay = [
    client_1.ExcerciseForce.PULL,
    client_1.ExcerciseForce.PULL,
    client_1.ExcerciseForce.PULL,
    client_1.ExcerciseForce.PULL,
    client_1.ExcerciseForce.PULL,
];
exports.pushDay = [
    client_1.ExcerciseForce.PUSH,
    client_1.ExcerciseForce.PUSH,
    client_1.ExcerciseForce.PUSH,
    client_1.ExcerciseForce.PUSH,
    client_1.ExcerciseForce.PUSH,
];
/////////
exports.upperDay = [
    graphql_1.MuscleRegionType.Chest,
    graphql_1.MuscleRegionType.UpperArm,
    graphql_1.MuscleRegionType.Shoulder,
    graphql_1.MuscleRegionType.Chest,
    graphql_1.MuscleRegionType.UpperArm,
    graphql_1.MuscleRegionType.Shoulder,
];
exports.lowerDay = [
    graphql_1.MuscleRegionType.Waist,
    graphql_1.MuscleRegionType.Hips,
    graphql_1.MuscleRegionType.Back,
    graphql_1.MuscleRegionType.Back,
    graphql_1.MuscleRegionType.Thighs,
    graphql_1.MuscleRegionType.Calves,
];
exports.chestAndArmDay = [
    graphql_1.MuscleRegionType.Chest,
    graphql_1.MuscleRegionType.Chest,
    graphql_1.MuscleRegionType.Chest,
    graphql_1.MuscleRegionType.UpperArm,
    graphql_1.MuscleRegionType.UpperArm,
    graphql_1.MuscleRegionType.UpperArm,
];
exports.backAndArmDay = [
    graphql_1.MuscleRegionType.Back,
    graphql_1.MuscleRegionType.Back,
    graphql_1.MuscleRegionType.Back,
    graphql_1.MuscleRegionType.UpperArm,
    graphql_1.MuscleRegionType.UpperArm,
    graphql_1.MuscleRegionType.UpperArm,
];
exports.legDay = [
    graphql_1.MuscleRegionType.Hips,
    graphql_1.MuscleRegionType.Hips,
    graphql_1.MuscleRegionType.Thighs,
    graphql_1.MuscleRegionType.Thighs,
    graphql_1.MuscleRegionType.Calves,
    graphql_1.MuscleRegionType.Calves,
];
exports.armDay = [
    graphql_1.MuscleRegionType.UpperArm,
    graphql_1.MuscleRegionType.UpperArm,
    graphql_1.MuscleRegionType.UpperArm,
    graphql_1.MuscleRegionType.Shoulder,
    graphql_1.MuscleRegionType.Shoulder,
    graphql_1.MuscleRegionType.Shoulder,
];
//# sourceMappingURL=constants.js.map