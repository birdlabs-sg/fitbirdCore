import { AuthenticationError } from "apollo-server";
const _ = require("lodash");

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
export const generateExcerciseMetadata = async (context: any, workout: any) => {
  const prisma = context.dataSources.prisma;
  const excercise_names = _.uniq(
    _.map(workout.excercise_sets, "excercise_name")
  );
  for (var excercise_name of excercise_names) {
    const excerciseMetadata = await prisma.excerciseMetadata.findUnique({
      where: {
        user_id_excercise_name: {
          user_id: context.user.user_id,
          excercise_name: excercise_name,
        },
      },
    });
    if (excerciseMetadata == null) {
      await prisma.excerciseMetadata.create({
        data: {
          user_id: context.user.user_id,
          excercise_name: excercise_name,
        },
      });
    }
  }
};

// updates a excerciseMetadata with the stats of the completed workout
export const updateExcerciseMetadataWithCompletedWorkout = async (
  context: any,
  workout: any
) => {
  // TODO: Algorithm to bring shift states
  // TODO: More efficient algo for comparison and updating
  const prisma = context.dataSources.prisma;
  const excercise_map: ExcerciseMap = _.groupBy(
    workout.excercise_sets,
    "excercise_name"
  );

  for (var [excercise_name, excercise_sets] of Object.entries(excercise_map)) {
    const oldMetadata = await prisma.excerciseMetadata.findUnique({
      where: {
        user_id_excercise_name: {
          user_id: context.user.user_id,
          excercise_name: excercise_name,
        },
      },
    });
    let best_set = {
      actual_weight: oldMetadata.best_weight,
      actual_reps: oldMetadata.best_rep,
      weight_unit: oldMetadata.weight_unit,
    };
    for (let excercise_set of excercise_sets) {
      if (best_set.actual_weight < excercise_set.actual_weight) {
        best_set = {
          actual_weight: excercise_set.actual_weight,
          actual_reps: excercise_set.actual_rep,
          weight_unit: excercise_set.weight_unit,
        };
      }
    }
    await prisma.excerciseMetadata.update({
      where: {
        user_id_excercise_name: {
          user_id: context.user.user_id,
          excercise_name: excercise_name,
        },
      },
      data: {
        best_weight: best_set.actual_weight,
        best_rep: best_set.actual_reps,
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
  if (onlyActive && targetWorkout.date_completed != null) {
    throw new Error("You cannot amend a completed workout.");
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
  previousWorkout: any
) => {
  const prisma = context.dataSources.prisma;
  const { excercise_sets, life_span, workout_name } = previousWorkout;

  const rateExcerciseSet = (excercise_set: any) => {
    // TODO: Can return a multiplier value based off how far he is from the bench mark next.
    if (excercise_set.actual_rep == null || excercise_set.actual_rep == null) {
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
  const lowerBound = 4;
  const upperBound = 8;

  const new_excercise_sets = [];
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

  // Create subsequent sets
  for (let excercise_set of excercise_sets) {
    const {
      actual_reps,
      actual_weight,
      excercise_set_id,
      workout_id,
      ...excercise_set_scaffold
    } = excercise_set;
    const excerciseSetRating = rateExcerciseSet(excercise_set);
    if (excerciseSetRating == "SKIPPED") {
      // Skipped => maintain the target reps and target weight of that set
      new_excercise_sets.push(excercise_set_scaffold);
    } else if (excerciseSetRating == "FAILED") {
      excercise_set_scaffold["target_reps"] = actual_reps;
      excercise_set_scaffold["target_weight"] = actual_weight;
      new_excercise_sets.push(excercise_set_scaffold);
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
        newTargetReps = (lowerBound + upperBound) / 2;
        newTargetWeight = actual_weight + 2.5;
      }
      excercise_set_scaffold.target_reps = newTargetReps;
      excercise_set_scaffold.target_weight = newTargetWeight;
      new_excercise_sets.push(excercise_set_scaffold);
    }
  }
  // Create the workout and slot behind the rest of the queue.
  await prisma.workout.create({
    data: {
      user_id: context.user.user_id,
      workout_name: workout_name,
      life_span: life_span - 1,
      order_index: await getActiveWorkoutCount(context),
      excercise_sets: {
        create: new_excercise_sets,
      },
    },
  });
};
