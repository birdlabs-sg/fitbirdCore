import { suggestedRepCalculator,suggestedWeightCalculator } from "./exerciseCalculators";
import { ExcerciseMetadata } from "@prisma/client";
import {
  ExcerciseMechanics,
} from "@prisma/client";
//invoke call only for weighted exercises

export const callibrator = async (
  excercise,
  excerciseRecord:ExcerciseMetadata,
  context: any
) => {
  let excercise_sets;
  let targetWeight;
  let targetReps;
  const user = context.user;
  if (excerciseRecord.best_rep != 0) {
    if(excercise.body_weight){
          //since 5 is the default number of sets
          targetReps = suggestedRepCalculator(excerciseRecord.best_rep,5);
          targetWeight= 0;
    }
    else{
        targetReps = user.isolated_movement_rep_upper_bound;
        targetWeight = suggestedWeightCalculator(excerciseRecord.best_weight,targetReps)
    }
  
  } else {
    // No previous data, so we add defaults
    if (
      excercise.body_weight == false &&
      excercise.excercise_mechanics == ExcerciseMechanics.COMPOUND
    ) {
      // Compound non-body weight excercises
      targetWeight = 0;
      targetReps = user.compound_movement_rep_lower_bound;
    } else if (
      excercise.body_weight == false &&
      excercise.excercise_mechanics == ExcerciseMechanics.ISOLATED
    ) {
      // Isolated non-body weight excercises
      targetWeight = 0;
      targetReps = user.isolated_movement_rep_lower_bound;
    } else if (
      excercise.body_weight == true &&
      excercise.excercise_mechanics == ExcerciseMechanics.ISOLATED
    ) {
      // body-weight, isolated excercise
      targetWeight = 0;
      targetReps = user.body_weight_rep_lower_bound;
    } else if (
      excercise.body_weight == true &&
      excercise.excercise_mechanics == ExcerciseMechanics.COMPOUND
    ) {
      // body-weight, compound excercise
      targetWeight = 0;
      targetReps = user.body_weight_rep_lower_bound;
    }
  }
  excercise_sets = new Array(5).fill({
    target_weight: targetWeight,
    weight_unit: "KG",
    target_reps: targetReps,
    actual_weight: null,
    actual_reps: null,
  });
  return excercise_sets
};
