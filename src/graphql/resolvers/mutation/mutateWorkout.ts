import {
  reorderActiveWorkouts,
  generateNextWorkout,
  getActiveWorkoutCount,
  checkExistsAndOwnership,
  getActiveWorkouts,
  generateExcerciseMetadata,
  updateExcerciseMetadataWithCompletedWorkout,
} from "../../../service/workout_manager";
import { onlyAuthenticated } from "../../../service/firebase_service";

export const generateWorkouts = async (_: any, args: any, context: any) => {
  onlyAuthenticated(context);
  const { no_of_workouts } = args;
  const prisma = context.dataSources.prisma;
  const generatedWorkouts = [];
  // Just a mockup for now. TODO: Create a service that links up with lichuan's recommendation algorithm
  for (let i = 0; i < no_of_workouts; i++) {
    generatedWorkouts.push(
      await prisma.workout.create({
        data: {
          user_id: context.user.user_id,
          order_index: await getActiveWorkoutCount(context),
          life_span: 25,
          workout_name: `Test workout: ${i}`,
          excercise_sets: {
            create: [
              {
                target_reps: 10,
                target_weight: 80,
                weight_unit: "KG",
                excercise_name: "Barbell Close Grip Bench Press",
                actual_weight: null,
                actual_reps: null,
              },
              {
                target_reps: 10,
                target_weight: 80,
                weight_unit: "KG",
                excercise_name: "Barbell Close Grip Bench Press",
                actual_weight: null,
                actual_reps: null,
              },
              {
                target_reps: 30,
                target_weight: 5,
                weight_unit: "KG",
                excercise_name: "Machine-assisted Triceps Dip",
                actual_reps: null,
                actual_weight: null,
              },
            ],
          },
        },
        include: {
          excercise_sets: true,
        },
      })
    );
  }
  return generatedWorkouts;
};

// Note: This resolver is only used when the user wishes to create new workout on existing ones.
// Assumption: active_workouts always have order_index with no gaps when sorted. For eg: 0,1,2,3 and not 0,2,3,5
export const createWorkout = async (_: any, args: any, context: any) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const { excercise_sets, ...otherArgs } = args;

  // Ensure that there is a max of 7 workouts
  if ((await getActiveWorkoutCount(context)) > 6) {
    throw Error("You can only have 7 active workouts.");
  }

  const workout = await prisma.workout.create({
    data: {
      user_id: context.user.user_id,
      order_index: await getActiveWorkoutCount(context),
      ...otherArgs,
      excercise_sets: {
        create: excercise_sets,
      },
    },
    include: {
      excercise_sets: true,
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
  const { workout_id, excercise_sets } = args;
  const prisma = context.dataSources.prisma;

  await checkExistsAndOwnership(context, workout_id, false);

  const completedWorkout = await prisma.workout.update({
    where: {
      workout_id: parseInt(workout_id),
    },
    data: {
      date_completed: new Date(),
      excercise_sets: {
        deleteMany: {},
        createMany: { data: excercise_sets },
      },
    },
    include: {
      excercise_sets: true,
    },
  });
  // Updates best set if available. TODO: Change excercise state
  await updateExcerciseMetadataWithCompletedWorkout(context, completedWorkout);
  await reorderActiveWorkouts(context, null, null);
  await generateNextWorkout(context, completedWorkout);

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
  const { workout_id, excercise_sets, ...otherArgs } = args;
  const prisma = context.dataSources.prisma;
  console.log("updateworkout");
  await checkExistsAndOwnership(context, workout_id, true);

  let updatedData = {
    ...otherArgs,
    ...(excercise_sets && {
      excercise_sets: {
        deleteMany: {},
        createMany: { data: excercise_sets },
      },
    }),
  };

  const updatedWorkout = await prisma.workout.update({
    where: {
      workout_id: parseInt(workout_id),
    },
    data: updatedData,
    include: {
      excercise_sets: true,
    },
  });

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
