import { ExcerciseForce } from "@prisma/client";
import { MuscleRegionType } from "../../../types/graphql";
import {
  pullDay,
  pushDay,
  upperDay,
  lowerDay,
  chestAndArmDay,
  backAndArmDay,
  legDay,
} from "./constants";

//two day splits
export const twoDaySplitPushPull: ExcerciseForce[][] = [pushDay, pullDay];
export const twoDaySplitMuscle: MuscleRegionType[][] = [upperDay, lowerDay];

//three day splits

//pending fix DO NOT TOUCH OR USE
export const threeDaySplitPushPull: ExcerciseForce[][] = [
  pushDay,
  pullDay,
  pushDay,
];
/////////
export const threeDaySplitMuscle: MuscleRegionType[][] = [
  upperDay,
  lowerDay,
  legDay,
];

//four day splits

//pending fix DO NOT TOUCH OR USE
export const fourDaySplitPushPull: ExcerciseForce[][] = [
  pushDay,
  pullDay,
  pushDay,
  pullDay,
];
//////////
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
