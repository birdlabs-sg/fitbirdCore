import { MuscleRegionType } from "../../../types/graphql";

/**
 * List that dictates what a generated workout would be
 */
export const workout_name_list = Object.freeze([
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
export const rotations_type = Object.freeze([
  [
    MuscleRegionType.Thighs,
    MuscleRegionType.Chest,
    MuscleRegionType.Back,
    MuscleRegionType.Shoulder,
    MuscleRegionType.UpperArm,
  ],
  [
    MuscleRegionType.Back,
    MuscleRegionType.Chest,
    MuscleRegionType.Shoulder,
    MuscleRegionType.Thighs,
    MuscleRegionType.UpperArm,
  ],
  [
    MuscleRegionType.Chest,
    MuscleRegionType.Back,
    MuscleRegionType.Shoulder,
    MuscleRegionType.Thighs,
    MuscleRegionType.UpperArm,
  ],
]);
