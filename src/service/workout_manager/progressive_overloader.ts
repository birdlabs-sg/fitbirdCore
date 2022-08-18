import { FailureReason } from "@prisma/client";
import { retrieveExerciseMetadata } from "./retrieveExerciseMetadata";
const categorizeExcerciseSet = (excercise_set: ExcerciseSet) => {
  // TODO: give a more accurate benchmark
  // We consider the set to fail when the actual reps is lower than the benchmark.
  // Bench marks are calculated as follows:
  // 1. At same weight, Bench mark = target reps
  // 2. At a lower weight, Bench mark = target reps * 1.15
  // 3. At a higher weight, Bench mark = target reps * 0.85
  if (
    excercise_set.actual_reps == null ||
    excercise_set.actual_weight == null
  ) {
    // guard clause
    return "SKIPPED";
  }
  var benchMark;
  var benchMarkWeight;
  switch (true) {
    case excercise_set.target_weight == excercise_set.actual_weight:
      // 1. At same weight
      benchMark = excercise_set.target_reps;
      break;
    case excercise_set.target_weight > excercise_set.actual_weight:
      // 1. At same weight
      benchMark = excercise_set.target_reps * 1.15;
      break;
    case excercise_set.target_weight < excercise_set.actual_weight:
      // 1. At same weight
      benchMark = excercise_set.target_reps * 0.85;
      break;
  }
  // setting the bench mark for weight
  if (excercise_set.target_reps == excercise_set.actual_reps) {
    benchMarkWeight = excercise_set.target_weight;
  } else if (excercise_set.actual_reps! < excercise_set.target_reps) {
    // increase the bench mark weight
    benchMarkWeight = excercise_set.target_weight * 1.025;
  } else {
    // decrease the bench mark weight
    benchMarkWeight = excercise_set.target_weight * 0.975;
  }

  if (
    excercise_set.actual_reps < benchMark ||
    excercise_set.actual_weight! < benchMarkWeight
  ) {
    return "FAILED";
  } else if (
    excercise_set.actual_reps == benchMark &&
    excercise_set.actual_weight! == benchMarkWeight
  ) {
    return "MAINTAINED";
  } else {
    return "EXCEED";
  }
};

const generateNextExerciseSets = (
  excercise_sets: ExcerciseSet[],
  upperBound: number,
  lowerBound: number,
  dropDifficultyForFailedSets: boolean = false
) => {
  const updatedSets = [];
  for (let excercise_set of excercise_sets) {
    // extract actual values and create a base scaffold for the next exerciseset
    const {
      actual_reps,
      actual_weight,
      excercise_set_id,
      workout_id,
      ...excercise_set_scaffold
    } = excercise_set;

    const category = categorizeExcerciseSet(excercise_set);

    if (category == "FAILED" || category == "SKIPPED") {
      if (dropDifficultyForFailedSets) {
        // Using target values as the base: Decrease by 1 rep. If already at lower bound, decrease the weight by 2.5% and drop back reps to upper bound
        let newTargetReps = excercise_set.target_reps - 1;
        let newTargetWeight = excercise_set.target_weight;
        if (newTargetReps < lowerBound) {
          // hit the lower bound, recalibrate
          newTargetReps = upperBound;
          newTargetWeight =
            excercise_set.target_weight -
            parseFloat((Math.round(actual_weight * 0.025 * 4) / 4).toFixed(2));
        }
        excercise_set_scaffold.target_reps = newTargetReps;
        excercise_set_scaffold.target_weight = newTargetWeight;
        updatedSets.push(excercise_set_scaffold);
      } else {
        // no change
        updatedSets.push(excercise_set_scaffold);
      }
    } else if (category == "MAINTAINED" || category == "EXCEED") {
      // Using actual values as the base: Increase by 1 rep. If already at upper bound, increase the weight by 2.5% and drop back reps to lower bound
      let newTargetReps = actual_reps + 1;
      let newTargetWeight = actual_weight;
      if (newTargetReps > upperBound) {
        // hit the upper bound, recalibrate
        newTargetReps = lowerBound;
        newTargetWeight =
          parseFloat((Math.round(actual_weight * 0.025 * 4) / 4).toFixed(2)) +
          actual_weight;
      }
      excercise_set_scaffold.target_reps = newTargetReps;
      excercise_set_scaffold.target_weight = newTargetWeight;
      updatedSets.push(excercise_set_scaffold);
    }
  }
  return updatedSets;
};

export const progressivelyOverload = async (
  excercise_set_groups: excerciseSetGroupInput[],
  context: any
) => {
  const prisma = context.dataSources.prisma;

  // retrieve the rep ranges for different types of exercises
  const compoundLowerBound = context.user.compound_movement_rep_lower_bound;
  const compoundUpperBound = context.user.compound_movement_rep_upper_bound;
  const isolatedLowerBound = context.user.isolated_movement_rep_lower_bound;
  const isolatedUpperBound = context.user.isolated_movement_rep_upper_bound;
  const bodyWeightLowerBound = context.user.body_weight_rep_lower_bound;
  const bodyWeightUpperBound = context.user.body_weight_rep_upper_bound;

  for (let excercise_set_group of excercise_set_groups) {
    // variable that holds the sets for the next workout
    var overloadedSets;

    // set the rep ranges based on what type of exercise it is
    var upperBound;
    var lowerBound;
    const excerciseData = await prisma.excercise.findUnique({
      where: {
        excercise_name: excercise_set_group.excercise_name,
      },
    });
    if (
      excerciseData.excercise_mechanics[0] == "COMPOUND" &&
      excerciseData.body_weight == false
    ) {
      upperBound = compoundUpperBound;
      lowerBound = compoundLowerBound;
    } else if (
      excerciseData.excercise_mechanics[0] == "ISOLATED" &&
      excerciseData.body_weight == false
    ) {
      upperBound = isolatedLowerBound;
      lowerBound = isolatedUpperBound;
    } else {
      upperBound = bodyWeightLowerBound;
      lowerBound = bodyWeightUpperBound;
    }

    // Based on the failure reason, route the type of overloading logic

    switch (excercise_set_group.failure_reason ?? "") {
      case FailureReason.INSUFFICIENT_SLEEP ||
        FailureReason.LOW_MOOD ||
        FailureReason.INSUFFICIENT_TIME: {
        // 1. (Failed sets/Skipped sets) No changes
        // 2. (Maintained sets) Using actual values as the base: Increase by 1 rep. If already at upper bound, increase the weight by 2.5% and drop back reps to lower bound
        // 3. (exceed sets) Using actual values as the base: increase by 1 rep. If already at upper bound, increase the weight by 2.5% and drop back reps to lower bound
        overloadedSets = generateNextExerciseSets(
          excercise_set_group.excercise_sets,
          upperBound,
          lowerBound
        );
        break;
      }
      case FailureReason.INSUFFICIENT_REST_TIME: {
        // 1. (Failed sets/Skipped sets) No changes
        // 2. (Maintained sets) Using actual values as the base: Increase by 1 rep. If already at upper bound, increase the weight by 2.5% and drop back reps to lower bound
        // 3. (exceed sets) Using actual values as the base: increase by 1 rep. If already at upper bound, increase the weight by 2.5% and drop back reps to lower bound
        // 4. Increase lower bound of rest time by 25%
        overloadedSets = generateNextExerciseSets(
          excercise_set_group.excercise_sets,
          upperBound,
          lowerBound
        );
        // TODO: create a helper to get exerciseMetadata. If dont have automatically generate one before returbning the generated exerciseMetadata.
        try {
          const metadata = await retrieveExerciseMetadata(
            context,
            excerciseData.excercise_name
          );
          var increaseRestTimeBy: number = Math.ceil(
            metadata.rest_time_lower_bound * 0.25
          );
          metadata.rest_time_lower_bound =
            metadata.rest_time_lower_bound + increaseRestTimeBy;
          metadata.rest_time_upper_bound =
            metadata.rest_time_upper_bound + increaseRestTimeBy;
          // TODO: Use the helper to change the rest timer.
          await prisma.excerciseMetadata.update({
            where: {
              user_id_excercise_name: {
                user_id: context.user.user_id,
                excercise_name: excerciseData.excercise_name,
              },
            },
            data: {
              ...metadata,
            },
          });
        } catch (e) {
          console.log(e);
        }
        break;
      }
      case FailureReason.TOO_DIFFICULT: {
        // 1. (Failed sets/Skipped sets) Using target values as base: Lower failed sets by 1 rep. If already at lower bound, decrease the weight by 2.5%
        // 2. (Maintained sets) Using actual values as the base: Increase by 1 rep. If already at upper bound, increase the weight by 2.5% and drop back reps to lower bound
        // 3. (exceed sets) Using actual values as the base: increase by 1 rep. If already at upper bound, increase the weight by 2.5% and drop back reps to lower bound
        overloadedSets = generateNextExerciseSets(
          excercise_set_group.excercise_sets,
          upperBound,
          lowerBound,
          true
        );
        break;
      }
      default: {
        // (Means no failure sets/ Skipped sets)
        // 1. (Maintained sets) Using actual values as the base: Increase by 1 rep. If already at upper bound, increase the weight by 2.5% and drop back reps to lower bound
        // 2. (exceed sets) Using actual values as the base: increase by 1 rep. If already at upper bound, increase the weight by 2.5% and drop back reps to lower bound
        overloadedSets = generateNextExerciseSets(
          excercise_set_group.excercise_sets,
          upperBound,
          lowerBound
        );
        break;
      }
    }
    excercise_set_group.excercise_sets = overloadedSets;
  }
  return excercise_set_groups;
};
