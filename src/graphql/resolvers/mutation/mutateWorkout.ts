import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import {
  generateNextWorkout,
  workoutGenerator,
  workoutGeneratorV2,
} from "../../../service/workout_manager/workout_generator/workout_generator";
import { Workout, WorkoutState, WorkoutType } from "@prisma/client";
import { AppContext } from "../../../types/contextType";
import {
  MutationUpdateWorkoutArgs,
  ExcerciseSetGroupInput,
  MutationCreateWorkoutArgs,
  MutationGenerateWorkoutsArgs,
  MutationUpdateWorkoutOrderArgs,
  MutationCompleteWorkoutArgs,
  MutationDeleteWorkoutArgs,
  MutationCreateProgramArgs,
} from "../../../types/graphql";
import { WorkoutWithExerciseSets } from "../../../types/Prisma";
import {
  checkExistsAndOwnership,
  exerciseSetGroupStateSeperator,
  extractMetadatas,
  formatExcerciseSetGroups,
  getActiveProgram,
  getActiveWorkoutCount,
  getActiveWorkouts,
} from "../../../service/workout_manager/utils";
import { reorderActiveWorkouts } from "../../../service/workout_manager/workout_order_manager";
import {
  generateOrUpdateExcerciseMetadata,
  updateExcerciseMetadataWithCompletedWorkout,
} from "../../../service/workout_manager/exercise_metadata_manager/exercise_metadata_manager";
import { assert } from "console";

/**
 * Generates @no_of_workouts number of workouts based on expert guidelines.
 * The generated workouts are of type: WorkoutType.AI_MANAGED
 */
export const generateWorkouts = async (
  parent: any,
  { no_of_workouts }: MutationGenerateWorkoutsArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  assert(no_of_workouts > 0 && no_of_workouts <= 6);
  var generatedWorkouts: WorkoutWithExerciseSets[];
  if (no_of_workouts >= 2) {
    generatedWorkouts = await workoutGeneratorV2(no_of_workouts, context);
  } else {
    generatedWorkouts = await workoutGenerator(no_of_workouts, context);
  }
  return generatedWorkouts;
};

/**
 * Regenerates AI_MANAGED workouts.
 * NOTE:
 *
 * 1. Workout generated are of type: WorkoutType.AI_MANAGED
 * 2. All existing active workouts of type: WorkoutType.AI_MANAGED are deleted
 */
export const regenerateWorkouts = async (
  parent: any,
  args: any,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const no_of_workouts = context.user.workout_frequency ?? 3;
  assert(no_of_workouts > 0 && no_of_workouts <= 6);

  const activeWorkouts = await getActiveWorkouts(
    context,
    WorkoutType.AI_MANAGED
  );
  const activeWorkoutIDS = activeWorkouts.map(
    (workout: any) => workout.workout_id
  );
  await prisma.workout.deleteMany({
    where: {
      workout_id: {
        in: activeWorkoutIDS,
      },
      workout_type: WorkoutType.AI_MANAGED,
    },
  });
  var generatedWorkouts: WorkoutWithExerciseSets[];
  if (no_of_workouts >= 2) {
    generatedWorkouts = await workoutGeneratorV2(no_of_workouts, context);
  } else {
    generatedWorkouts = await workoutGenerator(no_of_workouts, context);
  }
  return generatedWorkouts;
};

/**
 * Creates a new workout.
 * Assumption: active_workouts always have order_index with no gaps when sorted. For eg: 0,1,2,3 and not 0,2,3,5
 */
export async function createWorkout(
  parent: any,
  {
    excercise_set_groups,
    life_span,
    workout_name,
    workout_type,
  }: MutationCreateWorkoutArgs,
  context: AppContext
) {
  onlyAuthenticated(context);
  // Ensure that there is a max of 7 workouts
  if ((await getActiveWorkoutCount(context, workout_type)) > 6) {
    throw Error("You can only have 6 active workouts.");
  }

  const prisma = context.dataSources.prisma;

  const [excerciseSetGroups, excerciseMetadatas] = extractMetadatas(
    excercise_set_groups as ExcerciseSetGroupInput[]
  );

  const formattedExcerciseSetGroups =
    formatExcerciseSetGroups(excerciseSetGroups);

  const workout = await prisma.workout.create({
    data: {
      user_id: context.user.user_id,
      order_index: await getActiveWorkoutCount(context, workout_type),
      life_span: life_span,
      workout_name: workout_name,
      workout_type: workout_type,
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

/**
 * Reorders the given @workout_type active workoust.
 */
export const updateWorkoutOrder = async (
  parent: any,
  { oldIndex, newIndex, workout_type }: MutationUpdateWorkoutOrderArgs,
  context: AppContext
) => {
  await reorderActiveWorkouts(context, oldIndex, newIndex, workout_type);
  return {
    code: "200",
    success: true,
    message: "Successfully updated your workout!",
    workouts: await getActiveWorkouts(context, workout_type),
  };
};

/**
 * Completed the workout specified by @workout_id
 *
 * NOTE:
 * 1. Client have to send in all the excercise_sets or it will be treated that the excercise_set is to be deleted
 * 2. Active workouts returned will belong to the same type as the workout being completed.
 */
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
  await reorderActiveWorkouts(
    context,
    undefined,
    undefined,
    completedWorkout.workout_type
  );

  await generateNextWorkout(
    context,
    completedWorkout,
    next_workout_excercise_group_sets
  );

  return {
    code: "200",
    success: true,
    message: "Successfully updated your workout!",
    workouts: await getActiveWorkouts(context, completedWorkout.workout_type),
  };
};

/**
 * Updates the workout specified by @workout_id
 */
export const updateWorkout = async (
  _: any,
  { workout_id, excercise_set_groups, ...otherArgs }: MutationUpdateWorkoutArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);

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

/**
 * deletes the workout specified by @workout_id
 * Note:
 * Returns the active workouts that belong to the same group as the workout being delted
 */
export const deleteWorkout = async (
  _: any,
  { workout_id }: MutationDeleteWorkoutArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  // Get the workout of interest
  await checkExistsAndOwnership(context, workout_id);
  // delete the workout
  var deletedWorkout = await prisma.workout.delete({
    where: {
      workout_id: parseInt(workout_id),
    },
  });

  // reorder remaining workouts
  await reorderActiveWorkouts(
    context,
    undefined,
    undefined,
    deletedWorkout.workout_type
  );
  return {
    code: "200",
    success: true,
    message: "Successfully deleted your workout!",
    workouts: await getActiveWorkouts(context, deletedWorkout.workout_type),
  };
};

//creates a plan for the specified user marked by user_id, any existng active Programs will be marked as inactive
