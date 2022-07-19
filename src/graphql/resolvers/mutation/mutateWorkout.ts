import {
  reorderActiveWorkouts,
  generateNextWorkout,
  enforceWorkoutExistsAndOwnership,
} from "../../../service/workout_manager";
import { onlyAuthenticated } from "../../../service/firebase_service";

export const generateWorkouts = async (_: any, args: any, context: any) => {
  onlyAuthenticated(context);
  // custom logic for generating workouts based on user type
};

// Note: This resolver is only used when the user wishes to create new workout on existing ones.
// Assumption: active_workouts always have order_index with no gaps when sorted. For eg: 0,1,2,3 and not 0,2,3,5
export const createWorkout = async (_: any, args: any, context: any) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const { excercise_sets, ...otherArgs } = args;

  // Get all the active workouts
  const active_workouts = await prisma.workout.findMany({
    where: {
      date_completed: null,
      user_id: context.user.user_id,
    },
    orderBy: {
      order_index: "asc",
    },
  });

  const workout = await prisma.workout.create({
    data: {
      user_id: context.user.user_id,
      order_index: active_workouts.length,
      ...otherArgs,
      excercise_sets: {
        create: excercise_sets,
      },
    },
  });

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
  const prisma = context.dataSources.prisma;
  await reorderActiveWorkouts(context, oldIndex, newIndex);

  return {
    code: "200",
    success: true,
    message: "Successfully updated your workout!",
    workouts: await prisma.workout.findMany({
      where: {
        user_id: context.user.user_id,
        date_completed: null,
      },
      orderBy: {
        order_index: "asc",
      },
    }),
  };
};

// Note: Client have to send in all the excercise_sets or it will be treated that the excercise_set is to be deleted
export const completeWorkout = async (_: any, args: any, context: any) => {
  onlyAuthenticated(context);
  const { workout_id, excercise_sets } = args;
  const prisma = context.dataSources.prisma;

  // Get the workout of interest
  const targetWorkout = await prisma.workout.findUnique({
    where: {
      workout_id: parseInt(workout_id),
    },
  });
  enforceWorkoutExistsAndOwnership(context, targetWorkout);

  // Complete the workout object by filling date_completed and new excercise_sets. All excercise sets not present in excercise_sets_to_add will be removed from the relationship.
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
  await reorderActiveWorkouts(context, null, null);
  await generateNextWorkout(context, completedWorkout);

  // See if want to return back the reordered workouts or just the updatedWorkout
  return {
    code: "200",
    success: true,
    message: "Successfully updated your workout!",
    workout_id: workout_id,
    workouts: await prisma.workout.findMany({
      where: {
        date_completed: null,
        user_id: context.user.user_id,
      },
      orderBy: {
        order_index: "asc",
      },
      include: {
        excercise_sets: true,
      },
    }),
  };
};

// Note: Client have to send in all the excercise_sets with associated data or it will be treated that the excercise_set is to be deleted
export const updateWorkout = async (_: any, args: any, context: any) => {
  onlyAuthenticated(context);
  const { workout_id, excercise_sets, ...otherArgs } = args;
  const prisma = context.dataSources.prisma;
  // Get the workout of interest
  const targetWorkout = await prisma.workout.findUnique({
    where: {
      workout_id: parseInt(workout_id),
    },
  });
  enforceWorkoutExistsAndOwnership(context, targetWorkout);

  let updatedWorkout;
  if (excercise_sets != null) {
    // Update the workout object with provided args. All excercise sets not present in excercise_sets_to_add will be removed from the relationship.
    updatedWorkout = await prisma.workout.update({
      where: {
        workout_id: parseInt(workout_id),
      },
      data: {
        ...otherArgs,
        excercise_sets: {
          deleteMany: {},
          createMany: { data: excercise_sets },
        },
      },
      include: {
        excercise_sets: true,
      },
    });
  } else {
    updatedWorkout = await prisma.workout.update({
      where: {
        workout_id: parseInt(workout_id),
      },
      data: {
        ...otherArgs,
      },
      include: {
        excercise_sets: true,
      },
    });
  }
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
  const targetWorkout = await prisma.workout.findUnique({
    where: {
      workout_id: parseInt(args.workout_id),
    },
  });
  enforceWorkoutExistsAndOwnership(context, targetWorkout);

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
    workouts: await prisma.workout.findMany({
      where: {
        date_completed: null,
        user_id: context.user.user_id,
      },
      orderBy: {
        order_index: "asc",
      },
      include: {
        excercise_sets: true,
      },
    }),
  };
};
