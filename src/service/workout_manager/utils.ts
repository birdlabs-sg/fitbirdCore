import { PrismaExerciseSetGroupCreateArgs } from '../../types/Prisma';
import { AppContext } from '../../types/contextType';
import {
  ExcerciseMetaDataInput,
  ExcerciseSetGroupInput,
  ExcerciseSetGroupState,
  ExcerciseSetInput
} from '../../types/graphql';

import { generateExerciseMetadata } from './exercise_metadata_manager/exercise_metadata_manager';
import { WorkoutType } from '@prisma/client';
import { onlyCoach } from '../../service/firebase/firebase_service';
import { GraphQLError } from 'graphql';
import _ from 'lodash';

/**
 * Generates exercise sets and formats them to be used in Prisma
 * Note: If there is previous data from past workouts, it will duplicte those sets,
 * otherwise 5 black exercise sets will be created (Calibration workflow)
 */
export async function formatAndGenerateExcerciseSets(
  excercise_name: string,
  context: AppContext
) {
  await checkExerciseExists(context, excercise_name);
  const prisma = context.dataSources.prisma;
  const user = context.base_user!.User!;

  let excercise_sets_input: ExcerciseSetInput[] = [];

  // Checks if there is previous data, will use that instead
  const previousExcerciseSetGroup = await prisma.excerciseSetGroup.findFirst({
    where: {
      excercise_name: excercise_name,
      workout: {
        user_id: user.user_id,
        date_completed: { not: null }
      }
    },
    include: {
      excercise_sets: true
    }
  });

  // this function will generate excercise metadata if there is no previous metadata => when the user does it for the first time
  generateExerciseMetadata(context, excercise_name);
  //
  if (previousExcerciseSetGroup != null) {
    previousExcerciseSetGroup.excercise_sets.forEach((prev_set) => {
      const excercise_set_input = _.omit(
        prev_set,
        'excercise_set_group_id',
        'excercise_set_id'
      ) as ExcerciseSetInput;
      // Swapping of the "target" vs "actual" roles as now the target of new was actual of the previous
      excercise_set_input.target_reps = prev_set.actual_reps ?? 0;
      excercise_set_input.target_weight = prev_set.actual_weight ?? 0;
      excercise_set_input.actual_reps = undefined;
      excercise_set_input.actual_weight = undefined;
      //////
      excercise_sets_input.push(excercise_set_input);
    });
  } else {
    // No previous data
    excercise_sets_input = new Array(5).fill({
      target_weight: 0,
      weight_unit: 'KG',
      target_reps: 0,
      actual_weight: undefined,
      actual_reps: undefined
    });
  }
  return {
    excercise: { connect: { excercise_name: excercise_name } },
    excercise_set_group_state: ExcerciseSetGroupState.NormalOperation,
    excercise_sets: { create: excercise_sets_input }
  };
}

/**
 * Helps to format Exercise Set Groups into the form required by Prisma for update/creation
 */
export function formatExcerciseSetGroups(
  excerciseSetGroups: PrismaExerciseSetGroupCreateArgs[]
) {
  const formattedData = excerciseSetGroups.map(function (excerciseSetGroup) {
    const {
      excercise_sets,
      excercise_name,
      excercise_set_group_state,
      failure_reason
    } = excerciseSetGroup;
    return {
      failure_reason,
      excercise: {
        connect: {
          excercise_name: excercise_name
        }
      },
      excercise_set_group_state:
        excercise_set_group_state as ExcerciseSetGroupState,
      excercise_sets: {
        create: excercise_sets as ExcerciseSetInput[]
      }
    };
  });
  return formattedData;
}

/**
 * Helps to split the incoming object of type:  @ExcerciseSetGroupInput (This contains exerciseMetadata which is not found in the database)
 * The result is an array of 2 arrays.
 *
 * First is of type @PrismaExerciseSetGroupCreateArgs
 * Second is of type @ExcerciseMetaDataInput
 */
export function extractMetadatas(
  excerciseSetGroupsInput: ExcerciseSetGroupInput[]
): [PrismaExerciseSetGroupCreateArgs[], ExcerciseMetaDataInput[]] {
  const excercise_metadatas: Array<ExcerciseMetaDataInput> = [];

  const excerciseGroups: PrismaExerciseSetGroupCreateArgs[] =
    excerciseSetGroupsInput.map((excerciseSetGroupInput) => {
      const { excercise_metadata, ...excerciseSetGroup } =
        excerciseSetGroupInput;
      if (excercise_metadata) {
        excercise_metadatas.push(excercise_metadata);
      }
      return excerciseSetGroup as PrismaExerciseSetGroupCreateArgs;
    });

  return [excerciseGroups, excercise_metadatas];
}

/**
 * Helps to seggregate a list of ExerciseSetGroups into those that have been "Deleted"
 * and those that were "completed/skipped".
 *
 * Note:
 * 1. This will be used to generate the next workout
 * 2. This is only called by generateNextWorkout() function
 */
export function exerciseSetGroupStateSeperator(
  excercise_set_groups: PrismaExerciseSetGroupCreateArgs[]
): [PrismaExerciseSetGroupCreateArgs[], PrismaExerciseSetGroupCreateArgs[]] {
  const current_excercise_group_sets: Array<PrismaExerciseSetGroupCreateArgs> =
    [];
  const next_excercise_group_sets: Array<PrismaExerciseSetGroupCreateArgs> = [];
  for (const excercise_set_group of excercise_set_groups) {
    switch (excercise_set_group.excercise_set_group_state) {
      case ExcerciseSetGroupState.DeletedPermanantly:
        // 1. Will not be in subsequent workouts
        // 2. Will not be in the crrent workout
        break;
      case ExcerciseSetGroupState.DeletedTemporarily:
        // 1. Will conitnue to be in subsequent workouts
        // 2. Will not be in the current workout
        next_excercise_group_sets.push(excercise_set_group);
        break;
      case ExcerciseSetGroupState.ReplacementPermanantly:
        // 1. Will be in subsequent workouts
        // 2. Will be in the current workout
        next_excercise_group_sets.push(excercise_set_group);
        current_excercise_group_sets.push(excercise_set_group);
        break;
      case ExcerciseSetGroupState.ReplacementTemporarily:
        // 1. Will not be in subsequent workouts
        // 2. Will be in the current workout
        current_excercise_group_sets.push(excercise_set_group);
        break;
      case ExcerciseSetGroupState.NormalOperation:
        // 1. Will be in subsequent workouts
        // 2. Will be in the current workout
        next_excercise_group_sets.push(excercise_set_group);
        current_excercise_group_sets.push(excercise_set_group);
        break;
    }
  }
  return [current_excercise_group_sets, next_excercise_group_sets];
}

/**
 * Helps to get all active workouts (AKA the current rotation)
 *
 */
export async function getActiveWorkouts(
  context: AppContext,
  workout_type: WorkoutType
) {
  const prisma = context.dataSources.prisma;
  return await prisma.workout.findMany({
    where: {
      date_completed: null,
      user_id: context.base_user!.User!.user_id,
      workout_type: workout_type
    },
    orderBy: {
      order_index: 'asc'
    }
  });
}

/**
 * Helps to get all active workouts "COUNT" (AKA the current rotation)
 *
 * Note:
 * If you want the workouts itself, call getActiveWorkouts()
 */
export async function getActiveWorkoutCount(
  context: AppContext,
  workout_type: WorkoutType,
  user_id?: string
) {
  const prisma = context.dataSources.prisma;

    const workouts = await prisma.workout.findMany({
      where: {
        date_completed: null,
        user_id: user_id==undefined? context.base_user!.User!.user_id:parseInt(user_id),
        workout_type: workout_type,
      },
      orderBy: {
        order_index: "asc",
      },
    });
    return workouts.length;
}

/**
 * 1. Enforces that the requestor is the owner of the workout identified by @workout_id
 * 2. Also ensures that the workout of interests exists in the first place
 */
export async function checkExistsAndOwnership(
  context: AppContext,
  workout_id: string
) {
  const prisma = context.dataSources.prisma;
  const targetWorkout = await prisma.workout.findUnique({
    where: {
      workout_id: parseInt(workout_id)
    }
  });
  if (targetWorkout == null) {
    throw new GraphQLError('The workout does not exist.');
  }

  if (context.base_user?.User) {
    if (targetWorkout.user_id != context.base_user!.User!.user_id) {
      throw new GraphQLError("You are not authorized to remove this object", {
        extensions: {
          code: "FORBIDDEN",
        },
      });
    }
  } else {
    onlyCoach(context)
    if (targetWorkout.programProgram_id) {
      const targetProgram = await prisma.program.findUnique({
        where: {
          program_id: targetWorkout.programProgram_id,
        },
      });
      
      if (targetProgram?.coach_id != context.base_user!.coach!.coach_id) {
        throw new GraphQLError("You are not authorized to remove this object", {
          extensions: {
            code: "FORBIDDEN",
          },
        });
      }
      else{
        return targetProgram.user_id
      }
    } else {
      throw new GraphQLError("Program does not exist");
    }
  }
}

/**
 * Enforces that an exercise exists identified by @workout_id
 *
 */
export async function checkExerciseExists(
  context: AppContext,
  exercise_name: string
) {
  const prisma = context.dataSources.prisma;
  const exercise = await prisma.excercise.findUnique({
    where: {
      excercise_name: exercise_name
    }
  });
  if (exercise == null) {
    throw new GraphQLError('No exercise found');
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
/*COACH*/
export async function getActiveProgram(context: AppContext, user_id: string) {
  const prisma = context.dataSources.prisma;
  return await prisma.program.findFirst({
    where: {
      user_id: parseInt(user_id),
      coach_id: context.base_user!.coach!.coach_id!,
      is_active: true
    },
    include: {
      workouts: {
        orderBy: {
          order_index: 'asc'
        }
      }
    }
  });
}

// This function resets the active state of the program and workouts,
// 1. program is_active = false
export async function resetActiveProgramsForCoaches(
  context: AppContext,
  workout_type: WorkoutType,
  user_id: string
) {
  const prisma = context.dataSources.prisma;
  const date = new Date();
  //set all active programs to be inactive

  await prisma.program.updateMany({
    where: {
      user_id: parseInt(user_id),
      coach_id: context.base_user!.coach!.coach_id
    },
    data: {
      is_active: false
    }
  });

  await prisma.workout.updateMany({
    where: {
      date_completed: null,
      user_id: parseInt(user_id),
      workout_type: workout_type
    },
    data: {
      date_completed: date
    }
  });
}
