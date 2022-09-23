import { MuscleRegionType } from "../../../types/graphql";
import { ExcerciseForce } from "@prisma/client";
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

//pending fix DO NOT TOUCH OR USE
export const pullDay: ExcerciseForce[] = [
  ExcerciseForce.PULL,
  ExcerciseForce.PULL,
  ExcerciseForce.PULL,
  ExcerciseForce.PULL,
  ExcerciseForce.PULL,
];

export const pushDay: ExcerciseForce[] = [
  ExcerciseForce.PUSH,
  ExcerciseForce.PUSH,
  ExcerciseForce.PUSH,
  ExcerciseForce.PUSH,
  ExcerciseForce.PUSH,
];
/////////
export const upperDay: MuscleRegionType[] = [
  MuscleRegionType.Chest,
  MuscleRegionType.UpperArm,
  MuscleRegionType.Shoulder,
  MuscleRegionType.Chest,
  MuscleRegionType.UpperArm,
  MuscleRegionType.Shoulder,
];

export const lowerDay: MuscleRegionType[] = [
  MuscleRegionType.Waist,
  MuscleRegionType.Hips,
  MuscleRegionType.Back,
  MuscleRegionType.Back,
  MuscleRegionType.Thighs,
  MuscleRegionType.Calves,
];

export const chestAndArmDay: MuscleRegionType[] = [
  MuscleRegionType.Chest,
  MuscleRegionType.Chest,
  MuscleRegionType.Chest,
  MuscleRegionType.UpperArm,
  MuscleRegionType.UpperArm,
  MuscleRegionType.UpperArm,
];

export const backAndArmDay: MuscleRegionType[] = [
  MuscleRegionType.Back,
  MuscleRegionType.Back,
  MuscleRegionType.Back,
  MuscleRegionType.UpperArm,
  MuscleRegionType.UpperArm,
  MuscleRegionType.UpperArm,
];

export const legDay: MuscleRegionType[] = [
  MuscleRegionType.Hips,
  MuscleRegionType.Hips,
  MuscleRegionType.Thighs,
  MuscleRegionType.Thighs,
  MuscleRegionType.Calves,
  MuscleRegionType.Calves,
];

export const armDay: MuscleRegionType[] = [
  MuscleRegionType.UpperArm,
  MuscleRegionType.UpperArm,
  MuscleRegionType.UpperArm,
  MuscleRegionType.Shoulder,
  MuscleRegionType.Shoulder,
  MuscleRegionType.Shoulder,
];
