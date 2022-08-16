import { Workout } from "@prisma/client";
import { AuthenticationError } from "apollo-server";

const _ = require("lodash");
const util = require("util");

export const extractMetadatas = (
  rawExcerciseSetGroups: rawExcerciseSetGroupsInput[]
): [rawExcerciseSetGroupsInput[], excerciseMetaDataInput[]] => {
  var excercise_metadatas: Array<excerciseMetaDataInput> = [];
  rawExcerciseSetGroups = rawExcerciseSetGroups.map((rawExcerciseSetGroup) => {
    const { excercise_metadata, ...excerciseSetGroup } = rawExcerciseSetGroup;
    excercise_metadatas.push(excercise_metadata);
    return excerciseSetGroup;
  });
  return [rawExcerciseSetGroups, excercise_metadatas];
};

export const formatExcerciseSetGroups = (
  rawExcerciseSetGroups: rawExcerciseSetGroupsInput[]
) => {
  const formattedData = rawExcerciseSetGroups.map((rawExcerciseSetGroup) => ({
    ...rawExcerciseSetGroup,
    excercise_sets: { create: rawExcerciseSetGroup.excercise_sets },
  }));
  return formattedData;
};

// Transform the incoming excerciseSetGroups into excercise_sets
export const excerciseSetGroupsTransformer = (
  excercise_set_groups: Array<rawExcerciseSetGroupsInput>
): [rawExcerciseSetGroupsInput[], rawExcerciseSetGroupsInput[]] => {
  var current_excercise_group_sets: Array<rawExcerciseSetGroupsInput> = [];
  var next_excercise_group_sets: Array<rawExcerciseSetGroupsInput> = [];
  for (var excercise_set_group of excercise_set_groups) {
    switch (excercise_set_group.excercise_set_group_state) {
      case ExcerciseSetGroupState.DELETED_PERMANANTLY:
        // 1. Will not be in subsequent workouts
        // 2. Will not be in the crrent workout
        break;
      case ExcerciseSetGroupState.DELETED_TEMPORARILY:
        // 1. Will conitnue to be in subsequent workouts
        // 2. Will not be in the current workout
        next_excercise_group_sets.push(excercise_set_group);
        break;
      case ExcerciseSetGroupState.REPLACEMENT_PERMANANTLY:
        // 1. Will be in subsequent workouts
        // 2. Will be in the current workout
        next_excercise_group_sets.push(excercise_set_group);
        current_excercise_group_sets.push(excercise_set_group);
        break;
      case ExcerciseSetGroupState.REPLACEMENT_TEMPORARILY:
        // 1. Will not be in subsequent workouts
        // 2. Will be in the current workout
        current_excercise_group_sets.push(excercise_set_group);
        break;
      case ExcerciseSetGroupState.NORMAL_OPERATION:
        // 1. Will be in subsequent workouts
        // 2. Will be in the current workout
        next_excercise_group_sets.push(excercise_set_group);
        current_excercise_group_sets.push(excercise_set_group);
        break;
    }
  }
  return [current_excercise_group_sets, next_excercise_group_sets];
};

// Gets all active workouts
export const getActiveWorkouts = async (context: any) => {
  const prisma = context.dataSources.prisma;
  return await prisma.workout.findMany({
    where: {
      date_completed: null,
      user_id: context.user.user_id,
    },
    orderBy: {
      order_index: "asc",
    },
  });
};

// Generates excerciseMetadata if it's not available for any of the excercises in a workout
export const generateOrUpdateExcerciseMetadata = async (
  context: any,
  excercise_metadatas: excerciseMetaDataInput[]
) => {
  const prisma = context.dataSources.prisma;
  for (var excercise_metadata of excercise_metadatas) {
    const excerciseMetadata = await prisma.excerciseMetadata.findUnique({
      where: {
        user_id_excercise_name: {
          user_id: context.user.user_id,
          excercise_name: excercise_metadata.excercise_name,
        },
      },
    });
    if (excerciseMetadata == null) {
      // create one with the excerciseMetadata provided
      const metadata = await prisma.excerciseMetadata.create({
        data: {
          user_id: context.user.user_id,
          ...excercise_metadata,
        },
      });
    } else {
      // update the excerciseMetadata with provided ones
      const metadata = await prisma.excerciseMetadata.update({
        where: {
          user_id_excercise_name: {
            user_id: context.user.user_id,
            excercise_name: excercise_metadata.excercise_name,
          },
        },
        data: {
          user_id: context.user.user_id,
          ...excercise_metadata,
        },
      });
    }
  }
};

// updates a excerciseMetadata with the stats of the completed workout if present
export const updateExcerciseMetadataWithCompletedWorkout = async (
  context: any,
  workout: any
) => {
  // TODO: Refactor into progressive overload algo
  const prisma = context.dataSources.prisma;

  for (var excercise_group_set of workout.excercise_set_groups) {
    let oldMetadata = await prisma.excerciseMetadata.findUnique({
      where: {
        user_id_excercise_name: {
          user_id: context.user.user_id,
          excercise_name: excercise_group_set.excercise_name,
        },
      },
    });
    if (oldMetadata == null) {
      oldMetadata = await prisma.excerciseMetadata.create({
        data: {
          user_id: context.user.user_id,
          excercise_name: excercise_group_set.excercise_name,
        },
      });
    }
    let best_set = {
      actual_weight: oldMetadata.best_weight,
      actual_reps: oldMetadata.best_rep,
      weight_unit: oldMetadata.weight_unit,
    };

    for (let excercise_set of excercise_group_set.excercise_sets) {
      if (best_set.actual_weight < excercise_set.actual_weight) {
        best_set = {
          actual_weight: excercise_set.actual_weight,
          actual_reps: excercise_set.actual_reps,
          weight_unit: excercise_set.weight_unit,
        };
      }
    }
    await prisma.excerciseMetadata.update({
      where: {
        user_id_excercise_name: {
          user_id: context.user.user_id,
          excercise_name: excercise_group_set.excercise_name,
        },
      },
      data: {
        best_rep: best_set.actual_reps,
        best_weight: best_set.actual_weight,
        weight_unit: best_set.weight_unit,
        last_excecuted: new Date().toISOString(),
      },
    });
  }
};

export const getActiveWorkoutCount = async (context: any) => {
  const prisma = context.dataSources.prisma;
  const workouts = await prisma.workout.findMany({
    where: {
      date_completed: null,
      user_id: context.user.user_id,
    },
    orderBy: {
      order_index: "asc",
    },
  });
  return workouts.length;
};

export const checkExistsAndOwnership = async (
  context: any,
  workout_id: any,
  onlyActive: boolean
) => {
  const prisma = context.dataSources.prisma;
  const targetWorkout = await prisma.workout.findUnique({
    where: {
      workout_id: parseInt(workout_id),
    },
  });
  if (targetWorkout == null) {
    throw new Error("The workout does not exist.");
  }
  if (targetWorkout.user_id != context.user.user_id) {
    throw new AuthenticationError(
      "You are not authorized to remove this object"
    );
  }
};

export const reorderActiveWorkouts = async (
  context: any,
  oldIndex: number,
  newIndex: number
) => {
  const prisma = context.dataSources.prisma;
  const active_workouts = await prisma.workout.findMany({
    where: {
      date_completed: null,
      user_id: context.user.user_id,
    },
    orderBy: {
      order_index: "asc",
    },
  });
  if (oldIndex != null && newIndex != null) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    const workout = active_workouts.splice(oldIndex, 1)[0];
    active_workouts.splice(newIndex, 0, workout);
  }

  for (var i = 0; i < active_workouts.length; i++) {
    const { workout_id } = active_workouts[i];
    await prisma.workout.update({
      where: {
        workout_id: workout_id,
      },
      data: {
        order_index: i,
        excercise_sets: undefined,
      },
    });
  }
};

export const generateNextWorkout = async (
  context: any,
  previousWorkout: any,
  next_workout_excercise_set_groups: rawExcerciseSetGroupsInput[]
) => {
  const prisma = context.dataSources.prisma;
  const { life_span, workout_name } = previousWorkout;
  const rateExcerciseSet = (excercise_set: any) => {
    // TODO: Can return a multiplier value based off how far he is from the bench mark next
    if (
      excercise_set.actual_reps == null ||
      excercise_set.actual_weight == null
    ) {
      // guard clause
      return "SKIPPED";
    }
    var benchMark;
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
    if (excercise_set.actual_reps < benchMark) {
      return "FAILED";
    } else if (excercise_set.actual_reps == benchMark) {
      return "MAINTAINED";
    } else {
      return "EXCEED";
    }
  };

  const progressivelyOverload = async (excercise_set_groups: any) => {
    const compoundLowerBound = context.user.compound_movement_rep_lower_bound;
    const compoundUpperBound = context.user.compound_movement_rep_upper_bound;
    const isolatedLowerBound = context.user.isolated_movement_rep_lower_bound;
    const isolatedUpperBound = context.user.isolated_movement_rep_upper_bound;

    const bodyWeightLowerBound = context.user.body_weight_rep_lower_bound;
    const bodyWeightUpperBound = context.user.body_weight_rep_upper_bound;

    for (let excercise_set_group of excercise_set_groups) {
      const overloadedSets = [];
      for (let excercise_set of excercise_set_group.excercise_sets) {
        const {
          actual_reps,
          actual_weight,
          excercise_set_id,
          workout_id,
          ...excercise_set_scaffold
        } = excercise_set;
        const excerciseData = await prisma.excercise.findUnique({
          where: {
            excercise_name: excercise_set_group.excercise_name,
          },
        });
        var upperBound;
        var lowerBound;

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

        const excerciseSetRating = rateExcerciseSet(excercise_set);

        if (excerciseSetRating == "SKIPPED") {
          // Skipped => maintain the target reps and target weight of that set
          overloadedSets.push(excercise_set_scaffold);
        } else if (excerciseSetRating == "FAILED") {
          excercise_set_scaffold["target_reps"] = actual_reps;
          excercise_set_scaffold["target_weight"] = actual_weight;
          overloadedSets.push(excercise_set_scaffold);
        } else if (
          excerciseSetRating == "EXCEED" ||
          excerciseSetRating == "MAINTAINED"
        ) {
          // 2. Higher => maintain the actual reps and actual weight of that set + 1
          // 3. Maintain => increase by 1 rep
          // If hit the bound, we will increase weight by 2.5, set the mid point of the rep range
          let newTargetReps = actual_reps + 1;
          let newTargetWeight = actual_weight;
          if (newTargetReps > upperBound) {
            // hit the upper bound, recalibrate
            newTargetReps = lowerBound;
            newTargetWeight =
              parseFloat(
                (Math.round(actual_weight * 0.025 * 4) / 4).toFixed(2)
              ) + actual_weight;
          }
          excercise_set_scaffold.target_reps = newTargetReps;
          excercise_set_scaffold.target_weight = newTargetWeight;
          overloadedSets.push(excercise_set_scaffold);
        }
      }
      excercise_set_group.excercise_sets = overloadedSets;
    }
    return excercise_set_groups;
  };

  // TODO: give a more accurate benchmark
  // We consider the set to fail when the actual reps is lower than the benchmark.
  // Bench marks are calculated as follows:
  // 1. At same weight, Bench mark = target reps
  // 2. At a lower weight, Bench mark = target reps * 1.15
  // 3. At a higher weight, Bench mark = target reps * 0.85

  // We then generate the next sets using the progressive overload logic:
  // We will aim to increase the actualReps to the upper bound of the excerciseRepRange (stored in excerciseMetadata).
  // The default range is 4 - 8 reps
  // Once user hits upperBound of the excerciseRepRange, we will increase the weight by 2.5kg and continue the cycle.

  // How the sets are progressively overloaded:
  // 1. Failed => maintain the actual reps and actual weight of that set
  // 2. Higher => maintain the actual reps and actual weight of that set + 1
  // 3. Maintain => increase by 1 rep
  // Don't need progressive overload because it was NOT completed in previous workout
  const excercise_set_groups_without_progressive_overload = _.differenceWith(
    next_workout_excercise_set_groups,
    previousWorkout.excercise_set_groups,
    (x, y) => x["excercise_name"] === y["excercise_name"]
  );
  // Need progressive overload because it was completed in the previous workout
  const excercise_set_groups_to_progressive_overload = _.differenceWith(
    next_workout_excercise_set_groups,
    excercise_set_groups_without_progressive_overload,
    (x, y) => x["excercise_name"] === y["excercise_name"]
  );

  const progressively_overloaded_excercise_set_groups =
    await progressivelyOverload(excercise_set_groups_to_progressive_overload);

  // Combine the excerciseSetGroups together and set them to back to normal operation
  const finalExcerciseSetGroups =
    excercise_set_groups_without_progressive_overload
      .concat(progressively_overloaded_excercise_set_groups)
      .map((e) => ({
        ...e,
        excercise_set_group_state: ExcerciseSetGroupState.NORMAL_OPERATION,
      }));

  // Create the workout and slot behind the rest of the queue.
  await prisma.workout.create({
    data: {
      user_id: context.user.user_id,
      workout_name: workout_name,
      life_span: life_span - 1,
      order_index: await getActiveWorkoutCount(context),
      excercise_set_groups: {
        create: formatExcerciseSetGroups(finalExcerciseSetGroups),
      },
    },
  });
};
