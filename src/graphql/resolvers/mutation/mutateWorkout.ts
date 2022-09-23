import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import {
  generateNextWorkout,
  workoutGenerator,
  workoutGeneratorV2
} from "../../../service/workout_manager/workout_generator/workout_generator";
import { Workout, WorkoutState } from "@prisma/client";
import { AppContext } from "../../../types/contextType";
import {
  Maybe,
  MutationUpdateWorkoutArgs,
  ExcerciseSetGroupInput,
  MutationCreateWorkoutArgs,
  MutationGenerateWorkoutsArgs,
  MutationUpdateWorkoutOrderArgs,
  MutationCompleteWorkoutArgs,
  MutationDeleteWorkoutArgs,
} from "../../../types/graphql";
import { WorkoutWithExerciseSets } from "../../../types/Prisma";
import {
  checkExistsAndOwnership,
  exerciseSetGroupStateSeperator,
  extractMetadatas,
  formatExcerciseSetGroups,
  getActiveWorkoutCount,
  getActiveWorkouts,
} from "../../../service/workout_manager/utils";
import { reorderActiveWorkouts } from "../../../service/workout_manager/workout_order_manager";
import {
  generateOrUpdateExcerciseMetadata,
  updateExcerciseMetadataWithCompletedWorkout,
} from "../../../service/workout_manager/exercise_metadata_manager/exercise_metadata_manager";

export const generateWorkouts = async (
  parent: any,
  args: MutationGenerateWorkoutsArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const { no_of_workouts } = args;
  let generatedWorkouts = await workoutGeneratorV2(no_of_workouts, context);
  return generatedWorkouts;
};

export const regenerateWorkouts = async (
  parent: any,
  args: any,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const no_of_workouts = context.user.workout_frequency ?? 3;

  const activeWorkouts = await getActiveWorkouts(context);
  const activeWorkoutIDS = activeWorkouts.map(
    (workout: any) => workout.workout_id
  );
  await prisma.workout.deleteMany({
    where: {
      workout_id: {
        in: activeWorkoutIDS,
      },
    },
  });
  var generatedWorkouts = await workoutGeneratorV2(no_of_workouts, context);
  return generatedWorkouts;
};

// Note: This resolver is only used when the user wishes to create new workout on existing ones.
// Assumption: active_workouts always have order_index with no gaps when sorted. For eg: 0,1,2,3 and not 0,2,3,5
export async function createWorkout(
  parent: any,
  args: MutationCreateWorkoutArgs,
  context: AppContext
) {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const { excercise_set_groups, ...otherArgs } = args;

  const [excerciseSetGroups, excerciseMetadatas] = extractMetadatas(
    excercise_set_groups as ExcerciseSetGroupInput[]
  );

  // Ensure that there is a max of 7 workouts
  if ((await getActiveWorkoutCount(context)) > 6) {
    throw Error("You can only have 7 active workouts.");
  }

  const formattedExcerciseSetGroups =
    formatExcerciseSetGroups(excerciseSetGroups);

  const workout = await prisma.workout.create({
    data: {
      user_id: context.user.user_id,
      order_index: await getActiveWorkoutCount(context),
      ...otherArgs,
      excercise_set_groups: {
        create: formattedExcerciseSetGroups,
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
}

// Assumption: active_workouts always have order_index with no gaps when sorted. For eg: 0,1,2,3 and not 0,2,3,5
export const updateWorkoutOrder = async (
  parent: any,
  args: MutationUpdateWorkoutOrderArgs,
  context: AppContext
) => {
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
export const completeWorkout = async (
  parent: any,
  { workout_id, excercise_set_groups }: MutationCompleteWorkoutArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  await checkExistsAndOwnership(context, workout_id);

  const [excerciseSetGroups, excerciseMetadatas] = extractMetadatas(
    excercise_set_groups as ExcerciseSetGroupInput[]
  );
  const [
    current_workout_excercise_group_sets,
    next_workout_excercise_group_sets,
  ] = exerciseSetGroupStateSeperator(excerciseSetGroups);

  let completedWorkout: WorkoutWithExerciseSets;

  completedWorkout = await prisma.workout.update({
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

  // this is to reorder the rest before the workout is generated and inserted to the back
  await reorderActiveWorkouts(context, undefined, undefined);

  await generateNextWorkout(
    context,
    completedWorkout,
    next_workout_excercise_group_sets
  );

  return {
    code: "200",
    success: true,
    message: "Successfully updated your workout!",
    workouts: await getActiveWorkouts(context),
  };
};

// Note: Client have to send in all the excercise_sets with associated data or it will be treated that the excercise_set is to be deleted
// Note: This only allows active workouts
export const updateWorkout = async (
  _: any,
  args: MutationUpdateWorkoutArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const { workout_id, excercise_set_groups, ...otherArgs } = args;
  const prisma = context.dataSources.prisma;
  await checkExistsAndOwnership(context, workout_id);

  let formatedUpdatedData;

  if (excercise_set_groups != null) {
    var [excerciseSetGroups, excercise_metadatas] = extractMetadatas(
      excercise_set_groups as ExcerciseSetGroupInput[]
    );
    formatedUpdatedData = {
      ...otherArgs,
      ...{
        excercise_set_groups: {
          deleteMany: {},
          create: formatExcerciseSetGroups(excerciseSetGroups),
        },
      },
    };
    await generateOrUpdateExcerciseMetadata(context, excercise_metadatas);
  } else {
    formatedUpdatedData = {
      ...otherArgs,
    };
  }
  // extract out metadatas
  const updatedWorkout = await prisma.workout.update({
    where: {
      workout_id: parseInt(workout_id),
    },
    data: formatedUpdatedData,
    include: {
      excercise_set_groups: { include: { excercise_sets: true } },
    },
  });

  return {
    code: "200",
    success: true,
    message: "Successfully updated your workout!",
    workout: updatedWorkout,
  };
};

export const deleteWorkout = async (
  _: any,
  args: MutationDeleteWorkoutArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  // Get the workout of interest
  await checkExistsAndOwnership(context, args.workout_id);
  // delete the workout
  await prisma.workout.delete({
    where: {
      workout_id: parseInt(args.workout_id),
    },
  });
  // reorder remaining workouts
  await reorderActiveWorkouts(context, undefined, undefined);
  const activeworkouts: Maybe<Workout>[] = await getActiveWorkouts(context);
  return {
    code: "200",
    success: true,
    message: "Successfully deleted your workout!",
    workouts: activeworkouts,
  };
};
