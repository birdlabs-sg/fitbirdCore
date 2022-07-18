import { AuthenticationError } from "apollo-server";

export const enforceWorkoutExistsAndOwnership = (
  context: any,
  targetWorkout: any
) => {
  if (targetWorkout == null) {
    throw new Error("The workout does not exist.");
  }
  if (targetWorkout.workoutGroup.user_id != context.user.user_id) {
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
      workoutGroup: {
        user_id: context.user.user_id,
      },
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

export const formatExcerciseSets = (unformattedExcerciseSets: any) => {
  const cleaned_excercise_sets = [];
  for (let i = 0; i < unformattedExcerciseSets.length; i++) {
    const { excercise_set_id, excercise_id, ...cleaned_excercise_set } =
      unformattedExcerciseSets[i];
    cleaned_excercise_set["excercise_id"] = parseInt(excercise_id);
    cleaned_excercise_sets.push(cleaned_excercise_set);
  }
  return cleaned_excercise_sets;
};

export const generateNextWorkout = async (
  context: any,
  previousWorkout: any
) => {
  const prisma = context.dataSources.prisma;
  const { excercise_sets, workout_group_id, ...otherArgs } = previousWorkout;

  const rateExcerciseSet = (excercise_set: any) => {
    // TODO: Can return a multiplier value based off how far he is from the bench mark next.
    var benchMark;
    if (excercise_set.target_weight == excercise_set.actual_weight) {
      // 1. At same weight
      benchMark = excercise_set.target_reps;
    } else if (excercise_set.target_weight > excercise_set.actual_weight) {
      // 2. At a lower weight, Bench mark = target reps * 1.15
      benchMark = excercise_set.target_reps * 1.15;
    } else {
      // 3. At a higher weight, Bench mark = target reps * 0.85
      benchMark = excercise_set.target_reps * 0.85;
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
  // 4. Did not complete (Empty set) => reduce the total reps by 10%

  //Check for empty sets
  var haveEmptySet = false;
  for (let excercise_set of excercise_sets) {
    if (
      excercise_set.actual_reps == null ||
      excercise_set.actual_weight == null
    ) {
      haveEmptySet = true;
      break;
    }
  }
  // Create subsequent sets
  for (let excercise_set of excercise_sets) {
    if (
      excercise_set.actual_reps != null ||
      excercise_set.actual_weight != null
    ) {
      const {
        actual_reps,
        actual_weight,
        excercise_set_id,
        workout_id,
        ...excercise_set_scaffold
      } = excercise_set;
      if (rateExcerciseSet(excercise_set) == "FAILED") {
        // 1. Failed => maintain the actual reps and actual weight of that set
        new_excercise_sets.push(excercise_set_scaffold);
      } else if (
        rateExcerciseSet(excercise_set) == "EXCEED" ||
        rateExcerciseSet(excercise_set) == "MAINTAINED"
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
  }
  // Create the workout and slot behind the rest of the queue.
  const active_workouts = await prisma.workout.findMany({
    where: {
      date_completed: null,
      workoutGroup: {
        user_id: context.user.user_id,
      },
    },
    orderBy: {
      order_index: "asc",
    },
  });
  await prisma.workout.create({
    data: {
      workout_group_id: workout_group_id,
      order_index: active_workouts.length,
      excercise_sets: {
        create: new_excercise_sets,
      },
    },
  });
};
