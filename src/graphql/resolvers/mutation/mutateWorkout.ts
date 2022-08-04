import {
  reorderActiveWorkouts,
  generateNextWorkout,
  getActiveWorkoutCount,
  checkExistsAndOwnership,
  getActiveWorkouts,
  generateExcerciseMetadata,
  updateExcerciseMetadataWithCompletedWorkout,
  excerciseSetGroupsTransformer,
  formatExcerciseSetGroups,
} from "../../../service/workout_manager/workout_manager";
import { onlyAuthenticated } from "../../../service/firebase_service";
import { workoutGenerator } from "../../../service/workout_manager/workout_generator";
const util = require("util");

export const generateWorkouts = async (_: any, args: any, context: any) => {
  onlyAuthenticated(context);
  const { no_of_workouts } = args;
  const prisma = context.dataSources.prisma;
  // Just a mockup for now. TODO: Create a service that links up with lichuan's recommendation algorithm
  const generatedWorkouts = workoutGenerator(no_of_workouts, context);
  return generatedWorkouts;
};

// Note: This resolver is only used when the user wishes to create new workout on existing ones.
// Assumption: active_workouts always have order_index with no gaps when sorted. For eg: 0,1,2,3 and not 0,2,3,5
export const createWorkout = async (_: any, args: any, context: any) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const { excercise_set_groups, ...otherArgs } = args;

  // Ensure that there is a max of 7 workouts
  if ((await getActiveWorkoutCount(context)) > 6) {
    throw Error("You can only have 7 active workouts.");
  }

  const formattedExcerciseSetGroups =
    formatExcerciseSetGroups(excercise_set_groups);

  const workout = await prisma.workout.create({
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

  await generateExcerciseMetadata(context, workout);
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
  await reorderActiveWorkouts(context, oldIndex, newIndex);

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
  const [
    current_workout_excercise_group_sets,
    next_workout_excercise_group_sets,
  ] = excerciseSetGroupsTransformer(excercise_set_groups);

  const completedWorkout = await prisma.workout.update({
    where: {
      workout_id: parseInt(workout_id),
    },
    data: {
      date_completed: new Date(),
      excercise_set_groups: {
        deleteMany: {},
        create: formatExcerciseSetGroups(current_workout_excercise_group_sets),
      },
    },
    include: {
      excercise_set_groups: { include: { excercise_sets: true } },
    },
  });
  await generateExcerciseMetadata(context, completedWorkout);
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

  let updatedData = {
    ...otherArgs,
    ...(excercise_set_groups && {
      excercise_set_groups: {
        deleteMany: {},
        create: formatExcerciseSetGroups(excercise_set_groups),
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

  await generateExcerciseMetadata(context, updatedWorkout);

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
