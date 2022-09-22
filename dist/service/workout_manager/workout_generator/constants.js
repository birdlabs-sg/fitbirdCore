"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.rotations_type = exports.workout_name_list = void 0;
const graphql_1 = require("../../../types/graphql");
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
//# sourceMappingURL=constants.js.map