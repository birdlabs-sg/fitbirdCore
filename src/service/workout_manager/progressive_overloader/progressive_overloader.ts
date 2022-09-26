import { onlyAuthenticated } from "../../firebase/firebase_service";
import { AppContext } from "../../../types/contextType";
import { PrismaExerciseSetGroupCreateArgs } from "../../../types/Prisma";
import { ExcerciseSetInput, FailureReason } from "../../../types/graphql";
import { retrieveExerciseMetadata } from "../exercise_metadata_manager/exercise_metadata_manager";

/**
 * Takes in @excercise_set_groups as a base and returns a list of exercise_set_groups that have been overloaded
 * Note: If there are failed sets, the failure reason would determine how the overloader responds
 */
export const progressivelyOverload = async (
  excercise_set_groups: PrismaExerciseSetGroupCreateArgs[],
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  // retrieve the rep ranges for different types of exercises
  const compoundLowerBound = context.user.compound_movement_rep_lower_bound;
  const compoundUpperBound = context.user.compound_movement_rep_upper_bound;
  const isolatedLowerBound = context.user.isolated_movement_rep_lower_bound;
  const isolatedUpperBound = context.user.isolated_movement_rep_upper_bound;
  const bodyWeightLowerBound = context.user.body_weight_rep_lower_bound;
  const bodyWeightUpperBound = Infinity;

  for (let excercise_set_group of excercise_set_groups) {
    // variable that holds the sets for the next workout
    var overloadedSets: ExcerciseSetInput[] = [];

    // set the rep ranges based on what type of exercise it is
    var upperBound;
    var lowerBound;
    const excerciseData = await prisma.excercise.findUnique({
      where: {
        excercise_name: excercise_set_group.excercise_name,
      },
    });
    if (excerciseData == null) {
      return [];
    }
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
      upperBound = isolatedUpperBound;
      lowerBound = isolatedLowerBound;
    } else {
      upperBound = bodyWeightUpperBound;
      lowerBound = bodyWeightLowerBound;
    }

    // Based on the failure reason, route the type of overloading logic
    var excercise_sets = excercise_set_group.excercise_sets;
    switch (excercise_set_group.failure_reason ?? "") {
      case FailureReason.InsufficientSleep ||
        FailureReason.LowMood ||
        FailureReason.InsufficientRestTime: {
        // 1. (Failed sets/Skipped sets) No changes
        // 2. (Maintained sets) Using actual values as the base: Increase by 1 rep. If already at upper bound, increase the weight by 2.5% and drop back reps to lower bound
        // 3. (exceed sets) Using actual values as the base: increase by 1 rep. If already at upper bound, increase the weight by 2.5% and drop back reps to lower bound
        overloadedSets = generateOverloadedExerciseSets({
          excercise_sets,
          upperBound,
          lowerBound,
        });
        break;
      }
      case FailureReason.InsufficientRestTime: {
        // 1. (Failed sets/Skipped sets) No changes
        // 2. (Maintained sets) Using actual values as the base: Increase by 1 rep. If already at upper bound, increase the weight by 2.5% and drop back reps to lower bound
        // 3. (exceed sets) Using actual values as the base: increase by 1 rep. If already at upper bound, increase the weight by 2.5% and drop back reps to lower bound
        // 4. Increase lower bound of rest time by 25%
        overloadedSets = generateOverloadedExerciseSets({
          excercise_sets,
          upperBound,
          lowerBound,
        });
        // TODO: create a helper to get exerciseMetadata. If dont have automatically generate one before returbning the generated exerciseMetadata.
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

        break;
      }
      case FailureReason.TooDifficult: {
        // 1. (Failed sets/Skipped sets) Using target values as base: Lower failed sets by 1 rep. If already at lower bound, decrease the weight by 2.5%
        // 2. (Maintained sets) Using actual values as the base: Increase by 1 rep. If already at upper bound, increase the weight by 2.5% and drop back reps to lower bound
        // 3. (exceed sets) Using actual values as the base: increase by 1 rep. If already at upper bound, increase the weight by 2.5% and drop back reps to lower bound
        overloadedSets = generateOverloadedExerciseSets({
          excercise_sets,
          upperBound,
          lowerBound,
          dropDifficultyForFailedSets: true,
        });
        break;
      }
      default: {
        // (Means no failure sets/ Skipped sets)
        // 1. (Maintained sets) Using actual values as the base: Increase by 1 rep. If already at upper bound, increase the weight by 2.5% and drop back reps to lower bound
        // 2. (exceed sets) Using actual values as the base: increase by 1 rep. If already at upper bound, increase the weight by 2.5% and drop back reps to lower bound
        overloadedSets = generateOverloadedExerciseSets({
          excercise_sets,
          upperBound,
          lowerBound,
        });
        break;
      }
    }
    excercise_set_group.excercise_sets = overloadedSets;
  }
  return excercise_set_groups;
};

/**
 * Works for the progressivelyOverload() function.
 * Helps to generate the next set of overloaded exercises.
 *
 * Note:
 * 1. The rep range determines the limits that overloader can increase/decrease the reps by until the weight needs to change
 * 2. dropDifficultyForFailedSets is used in the case where we DON't want to touch the failed sets. (Because there was a legitamate reason for the failure)
 */
function generateOverloadedExerciseSets({
  excercise_sets,
  upperBound,
  lowerBound,
  dropDifficultyForFailedSets = false,
}: {
  excercise_sets: ExcerciseSetInput[];
  upperBound: number;
  lowerBound: number;
  dropDifficultyForFailedSets?: boolean;
}) {
  const updatedSets: ExcerciseSetInput[] = [];
  for (let excerciseSet of excercise_sets) {
    // extract actual values and create a base scaffold for the next exerciseset
    const { actual_reps, actual_weight, ...excercise_set_scaffold } =
      excerciseSet;

    const category = categorizeExcerciseSet({ excercise_set: excerciseSet });

    if (category == "FAILED" || category == "SKIPPED") {
      if (dropDifficultyForFailedSets) {
        // Using target values as the base: Decrease by 1 rep. If already at lower bound, decrease the weight by 2.5% and drop back reps to upper bound
        let newTargetReps = excerciseSet.target_reps - 1;
        let newTargetWeight = excerciseSet.target_weight;
        if (newTargetReps < lowerBound) {
          // hit the lower bound, recalibrate
          newTargetReps = upperBound;
          newTargetWeight =
            excerciseSet.target_weight -
            parseFloat(
              (Math.round(newTargetWeight * 0.025 * 4) / 4).toFixed(2)
            );
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
      let newTargetReps: number = (actual_reps ?? 0) + 1;
      let newTargetWeight: number = actual_weight ?? 0;
      if (newTargetReps > upperBound) {
        // hit the upper bound, recalibrate
        newTargetReps = lowerBound;
        if (newTargetReps < 5) {
          // Because of Math.round, anything below 5 will get rounded down to the number itself.
          newTargetWeight = newTargetWeight + 1.25;
        } else {
          newTargetWeight =
            parseFloat(
              (Math.round(newTargetWeight * 0.025 * 4) / 4).toFixed(2)
            ) + actual_weight!;
        }
      }
      excercise_set_scaffold.target_reps = newTargetReps;
      excercise_set_scaffold.target_weight = newTargetWeight!;
      updatedSets.push(excercise_set_scaffold);
    }
  }
  return updatedSets;
}

/**
 * Works for the progressivelyOverload() function.
 * Function to determine if an exercise set is a PASS/FAIL/EXCEED
 */
function categorizeExcerciseSet({
  excercise_set,
}: {
  excercise_set: ExcerciseSetInput;
}) {
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
  var benchMarkRep: number;
  var benchMarkWeight: number;
  switch (true) {
    case excercise_set.target_weight > excercise_set.actual_weight:
      // 1. Lower weight
      benchMarkRep = excercise_set.target_reps * 1.15;
      break;
    case excercise_set.target_weight < excercise_set.actual_weight:
      // 2. Higher weight
      benchMarkRep = excercise_set.target_reps * 0.85;
      break;
    default:
      // 3. At same weight
      benchMarkRep = excercise_set.target_reps;
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
    excercise_set.actual_reps < benchMarkRep ||
    excercise_set.actual_weight! < benchMarkWeight
  ) {
    return "FAILED";
  } else if (
    excercise_set.actual_reps == benchMarkRep &&
    excercise_set.actual_weight! == benchMarkWeight
  ) {
    return "MAINTAINED";
  } else {
    return "EXCEED";
  }
}
