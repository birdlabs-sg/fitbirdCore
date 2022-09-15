import { AuthenticationError } from "apollo-server";
import { progressivelyOverload } from "./progressive_overloader";

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
  excercise_metadatas["last_excecuted"] =
    excercise_metadatas["last_excecuted"] != null
      ? new Date(excercise_metadatas["last_excecuted"])
      : null;
  for (var excercise_metadata of excercise_metadatas) {
    delete excercise_metadata["last_excecuted"];
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
      await prisma.excerciseMetadata.create({
        data: {
          user_id: context.user.user_id,
          ...excercise_metadata,
        },
      });
    } else {
      // update the excerciseMetadata with provided ones

      await prisma.excerciseMetadata.update({
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
      include: {
        excercise: true,
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

    // TODO: a way to select best set that takes into account both weight and rep
    let best_set = {
      actual_weight: oldMetadata.best_weight,
      actual_reps: oldMetadata.best_rep,
      weight_unit: oldMetadata.weight_unit,
    };

    for (let excercise_set of excercise_group_set.excercise_sets) {
      if (oldMetadata.excercise.body_weight == true) {
        if (best_set.actual_reps < excercise_set.actual_reps) {
          best_set = {
            actual_weight: excercise_set.actual_weight,
            actual_reps: excercise_set.actual_reps,
            weight_unit: excercise_set.weight_unit,
          };
        }
      } else {
        if (best_set.actual_weight < excercise_set.actual_weight) {
          best_set = {
            actual_weight: excercise_set.actual_weight,
            actual_reps: excercise_set.actual_reps,
            weight_unit: excercise_set.weight_unit,
          };
        }
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
        last_excecuted: new Date(),
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

  // Don't need progressive overload because it was NOT completed in previous workout (It was temporarily replaced or removed)
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
    await progressivelyOverload(
      excercise_set_groups_to_progressive_overload,
      context
    );

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
