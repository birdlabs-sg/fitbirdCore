import {
  Equipment,
  Excercise,
  ExcerciseMechanics,
  MuscleRegionType,
  ExcerciseForce,
} from "@prisma/client";

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

export const upperDay: MuscleRegionType[] = [
  MuscleRegionType.CHEST,
  MuscleRegionType.UPPER_ARM,
  MuscleRegionType.SHOULDER,
  MuscleRegionType.CHEST,
  MuscleRegionType.UPPER_ARM,
  MuscleRegionType.SHOULDER,
];

export const lowerDay: MuscleRegionType[] = [
  MuscleRegionType.WAIST,
  MuscleRegionType.HIPS,
  MuscleRegionType.BACK,
  MuscleRegionType.BACK,
  MuscleRegionType.THIGHS,
  MuscleRegionType.CALVES,
];

export const chestAndArmDay: MuscleRegionType[] = [
  MuscleRegionType.CHEST,
  MuscleRegionType.CHEST,
  MuscleRegionType.CHEST,
  MuscleRegionType.UPPER_ARM,
  MuscleRegionType.UPPER_ARM,
  MuscleRegionType.UPPER_ARM,
];

export const backAndArmDay: MuscleRegionType[] = [
  MuscleRegionType.BACK,
  MuscleRegionType.BACK,
  MuscleRegionType.BACK,
  MuscleRegionType.UPPER_ARM,
  MuscleRegionType.UPPER_ARM,
  MuscleRegionType.UPPER_ARM,
];

export const legDay: MuscleRegionType[] = [
  MuscleRegionType.HIPS,
  MuscleRegionType.HIPS,
  MuscleRegionType.THIGHS,
  MuscleRegionType.THIGHS,
  MuscleRegionType.CALVES,
  MuscleRegionType.CALVES,
];

export const armDay: MuscleRegionType[] = [
  MuscleRegionType.UPPER_ARM,
  MuscleRegionType.UPPER_ARM,
  MuscleRegionType.UPPER_ARM,
  MuscleRegionType.SHOULDER,
  MuscleRegionType.SHOULDER,
  MuscleRegionType.SHOULDER,
];
