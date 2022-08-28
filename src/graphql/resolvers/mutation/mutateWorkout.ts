import {
  reorderActiveWorkouts,
  generateNextWorkout,
  getActiveWorkoutCount,
  checkExistsAndOwnership,
  getActiveWorkouts,
  updateExcerciseMetadataWithCompletedWorkout,
  excerciseSetGroupsTransformer,
  formatExcerciseSetGroups,
  extractMetadatas,
  generateOrUpdateExcerciseMetadata,
} from "../../../service/workout_manager/workout_manager";
import { onlyAuthenticated } from "../../../service/firebase_service";
import { workoutGenerator } from "../../../service/workout_manager/workout_generator";
import { Workout, WorkoutState } from "@prisma/client";
const util = require("util");

export const generateWorkouts = async (_: any, args: any, context: any) => {
  onlyAuthenticated(context);
  const { no_of_workouts } = args;
  const prisma = context.dataSources.prisma;
  // Just a mockup for now. TODO: Create a service that links up with lichuan's recommendation algorithm
  let generatedWorkouts;
  try {
    generatedWorkouts = workoutGenerator(no_of_workouts, context);
  } catch (e) {
    console.log(e);
  }
  return generatedWorkouts;
};

// Note: This resolver is only used when the user wishes to create new workout on existing ones.
// Assumption: active_workouts always have order_index with no gaps when sorted. For eg: 0,1,2,3 and not 0,2,3,5
export const createWorkout = async (_: any, args: any, context: any) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const { excercise_set_groups, ...otherArgs } = args;

  const [excerciseSetGroups, excerciseMetadatas] =
    extractMetadatas(excercise_set_groups);

  // Ensure that there is a max of 7 workouts
  if ((await getActiveWorkoutCount(context)) > 6) {
    throw Error("You can only have 7 active workouts.");
  }

  const formattedExcerciseSetGroups =
    formatExcerciseSetGroups(excerciseSetGroups);

  const workout: Workout = await prisma.workout.create({
    data: {
      user_id: context.user.user_id,
      order_index: await getActiveWorkoutCount(context),
      ...otherArgs,
      excercise_set_groups: {
        create: formattedExcerciseSetGroups,
      },
    },
    include: {
      excercise_set_groups: {
        include: { excercise_sets: true },
      },
    },
  });
  await generateOrUpdateExcerciseMetadata(context, excerciseMetadatas);

  return {
    code: "200",
    success: true,
    message: "Successfully created a workout.",
    workout: workout,
  };
};

// Assumption: active_workouts always have order_index with no gaps when sorted. For eg: 0,1,2,3 and not 0,2,3,5
export const updateWorkoutOrder = async (_: any, args: any, context: any) => {
  let { oldIndex, newIndex } = args;
  try {
    await reorderActiveWorkouts(context, oldIndex, newIndex);
  } catch (e) {
    console.log(e);
  }

  return {
    code: "200",
    success: true,
    message: "Successfully updated your workout!",
    workouts: await getActiveWorkouts(context),
  };
};

// Note: Client have to send in all the excercise_sets or it will be treated that the excercise_set is to be deleted
export const completeWorkout = async (_: any, args: any, context: any) => {
  onlyAuthenticated(context);
  const { workout_id, excercise_set_groups } = args;
  const prisma = context.dataSources.prisma;
  await checkExistsAndOwnership(context, workout_id, false);

  const [excerciseSetGroups, excerciseMetadatas] =
    extractMetadatas(excercise_set_groups);

  const [
    current_workout_excercise_group_sets,
    next_workout_excercise_group_sets,
  ] = excerciseSetGroupsTransformer(excerciseSetGroups);

  const completedWorkout: Workout = await prisma.workout.update({
    where: {
      workout_id: parseInt(workout_id),
    },
    data: {
      date_completed: new Date(),
      workout_state: WorkoutState.COMPLETED,
      excercise_set_groups: {
        deleteMany: {},
        create: formatExcerciseSetGroups(current_workout_excercise_group_sets),
      },
    },
    include: {
      excercise_set_groups: { include: { excercise_sets: true } },
    },
  });

  // in-case there is no associated excercise metadata
  await generateOrUpdateExcerciseMetadata(context, excerciseMetadatas);

  await updateExcerciseMetadataWithCompletedWorkout(context, completedWorkout);

  await reorderActiveWorkouts(context, null, null);
  await generateNextWorkout(
    context,
    completedWorkout,
    next_workout_excercise_group_sets
  );

  return {
    code: "200",
    success: true,
    message: "Successfully updated your workout!",
    workout_id: workout_id,
    workouts: await getActiveWorkouts(context),
  };
};

// Note: Client have to send in all the excercise_sets with associated data or it will be treated that the excercise_set is to be deleted
// Note: This only allows active workouts
export const updateWorkout = async (_: any, args: any, context: any) => {
  onlyAuthenticated(context);
  const { workout_id, excercise_set_groups, ...otherArgs } = args;
  const prisma = context.dataSources.prisma;
  await checkExistsAndOwnership(context, workout_id, false);

  // extract out metadatas
  const excercise_metadatas = [];
  const excerciseSetGroups = excercise_set_groups?.map(
    (excercise_set_group) => {
      const { excercise_metadata, ...excerciseSetGroup } = excercise_set_group;
      excercise_metadatas.push(excercise_metadata);
      return excerciseSetGroup;
    }
  );

  let updatedData = {
    ...otherArgs,
    ...(excerciseSetGroups && {
      excercise_set_groups: {
        deleteMany: {},
        create: formatExcerciseSetGroups(excerciseSetGroups),
      },
    }),
  };

  const updatedWorkout = await prisma.workout.update({
    where: {
      workout_id: parseInt(workout_id),
    },
    data: updatedData,
    include: {
      excercise_set_groups: { include: { excercise_sets: true } },
    },
  });

  await generateOrUpdateExcerciseMetadata(context, excercise_metadatas);

  return {
    code: "200",
    success: true,
    message: "Successfully updated your workout!",
    workout: updatedWorkout,
  };
};

export const deleteWorkout = async (_: any, args: any, context: any) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  // Get the workout of interest
  await checkExistsAndOwnership(context, args.workout_id, false);
  // delete the workout
  await prisma.workout.delete({
    where: {
      workout_id: parseInt(args.workout_id),
    },
  });
  // reorder remaining workouts
  await reorderActiveWorkouts(context, null, null);
  return {
    code: "200",
    success: true,
    message: "Successfully deleted your workout!",
    workouts: await getActiveWorkouts(context),
  };
};
