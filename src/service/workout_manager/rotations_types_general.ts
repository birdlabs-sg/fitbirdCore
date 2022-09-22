import {
  Equipment,
  Excercise,
  ExcerciseMechanics,
  MuscleRegionType,
  PrismaClient,
  User,
  Workout,
  ExcerciseForce,
} from "@prisma/client";
import {
  pullDay,
  pushDay,
  upperDay,
  lowerDay,
  chestAndArmDay,
  backAndArmDay,
  legDay,
} from "./workout_groups";

//two day splits
export const twoDaySplitPushPull: ExcerciseForce[][] = [pushDay, pullDay];
export const twoDaySplitMuscle: MuscleRegionType[][] = [upperDay, lowerDay];

//three day splits
export const threeDaySplitPushPull: ExcerciseForce[][] = [
  pushDay,
  pullDay,
  pushDay,
];
export const threeDaySplitMuscle: MuscleRegionType[][] = [
  upperDay,
  lowerDay,
  legDay,
];

//four day splits
export const fourDaySplitPushPull: ExcerciseForce[][] = [
  pushDay,
  pullDay,
  pushDay,
  pullDay,
];
export const fourDaySplitMuscle: MuscleRegionType[][] = [
  upperDay,
  lowerDay,
  upperDay,
  lowerDay,
];

//five day splits
export const fiveDaySplit: MuscleRegionType[][] = [
  chestAndArmDay,
  backAndArmDay,
  legDay,
  upperDay,
  lowerDay,
];

//six day splits
export const sixDaySplit: MuscleRegionType[][] = [
  upperDay,
  lowerDay,
  legDay,
  upperDay,
  lowerDay,
  legDay,
];
