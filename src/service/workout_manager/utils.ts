import { PrismaExerciseSetGroupCreateArgs } from "../../types/Prisma";
import { AppContext } from "../../types/contextType";
import {
  ExcerciseMetaDataInput,
  ExcerciseSetGroupInput,
  ExcerciseSetGroupState,
  ExcerciseSetInput,
  PresetExcerciseSetInput,
  PresetWorkoutInput,
  PresetExcerciseSetGroup,
} from "../../types/graphql";

import { generateExerciseMetadata } from "./exercise_metadata_manager/exercise_metadata_manager";
import { PresetExcerciseSetGroupInput } from "../../types/graphql";
import { GraphQLError } from "graphql";
import _ from "lodash";

/**
 * Generates exercise sets and formats them to be used in Prisma
 * Note: If there is previous data from past workouts, it will duplicte those sets,
 * otherwise 5 black exercise sets will be created (Calibration workflow)
 */
export async function formatAndGenerateExcerciseSets(
  exercise_name: string,
  context: AppContext
) {
  await checkExerciseExists({ context, exercise_name });
  const prisma = context.dataSources.prisma;

  let excercise_sets_input: ExcerciseSetInput[] = [];

  // Checks if there is previous data, will use that instead
  const previousExcerciseSetGroup = await prisma.excerciseSetGroup.findFirst({
    where: {
      excercise_name: exercise_name,
      workout: {
        Program: {
          user_id: context.base_user?.User?.user_id,
        },
        date_closed: { not: null },
      },
    },
    include: {
      excercise_sets: true,
    },
  });

  // this function will generate excercise metadata if there is no previous metadata => when the user does it for the first time
  generateExerciseMetadata(context, exercise_name);
  //
  if (previousExcerciseSetGroup != null) {
    previousExcerciseSetGroup.excercise_sets.forEach((prev_set) => {
      const excercise_set_input = _.omit(
        prev_set,
        "excercise_set_group_id",
        "excercise_set_id"
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
      target_reps: 0,
      actual_weight: undefined,
      actual_reps: undefined,
    });
  }
  return {
    excercise: { connect: { excercise_name: exercise_name } },
    excercise_set_group_state: ExcerciseSetGroupState.NormalOperation,
    excercise_sets: { create: excercise_sets_input },
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
      failure_reason,
    } = excerciseSetGroup;
    return {
      failure_reason,
      excercise: {
        connect: {
          excercise_name: excercise_name,
        },
      },
      excercise_set_group_state:
        excercise_set_group_state as ExcerciseSetGroupState,
      excercise_sets: {
        create: excercise_sets.map((set) => {
          // set it back
          set.to_skip = false;
          return set;
        }),
      },
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
 * Helps to get all active workouts "COUNT" (AKA the current rotation)
 *
 * Note:
 * If you want the workouts itself, call getActiveWorkouts()
 */
export async function getActiveWorkout({
  context,
  program_id,
}: {
  context: AppContext;
  program_id: string;
  user_id?: string;
}) {
  const prisma = context.dataSources.prisma;
  const workouts = await prisma.workout.findMany({
    where: {
      date_closed: null,
      programProgram_id: parseInt(program_id),
    },
  });
  return { active_workouts: workouts, count: workouts.length };
}

/**
 * 1. Enforces that the requestor is the owner of the workout identified by @workout_id
 * 2. Also ensures that the workout of interests exists in the first place
 */
export async function checkProgramExistenceAndOwnership({
  context,
  program_id,
  user_id,
}: {
  context: AppContext;
  program_id: string;
  user_id?: string;
}) {
  const prisma = context.dataSources.prisma;
  let final_user_id: number;
  if (user_id) {
    final_user_id = parseInt(user_id);
  } else if (context.base_user?.User?.user_id) {
    final_user_id = context.base_user?.User?.user_id;
  } else {
    throw new GraphQLError("User_id is not passed in implicitly/explicitly.");
  }

  const targetProgram = await prisma.program.findUniqueOrThrow({
    where: {
      program_id: parseInt(program_id),
    },
  });
  if (targetProgram.user_id != final_user_id) {
    throw new GraphQLError("You are not authorized to access this program", {
      extensions: {
        code: "FORBIDDEN",
      },
    });
  }
}

/**
 * Enforces that the requestor is the owner of the workout (and that it exists) identified by @workout_id
 * Note: When @user_id is specified, function will user that instead. I.E. when using this function in the POV of a coach, ensure that @user_id is passed in.
 */
export async function checkExistsAndOwnership({
  context,
  workout_id,
  user_id,
}: {
  context: AppContext;
  workout_id: string;
  user_id?: string;
}) {
  const prisma = context.dataSources.prisma;
  let final_user_id: number;
  if (user_id) {
    final_user_id = parseInt(user_id);
  } else if (context.base_user?.User?.user_id) {
    final_user_id = context.base_user?.User?.user_id;
  } else {
    throw new GraphQLError("User_id is not passed in implicitly/explicitly.");
  }
  const targetWorkout = await prisma.workout.findUniqueOrThrow({
    where: {
      workout_id: parseInt(workout_id),
    },
    include: { Program: true },
  });

  if (targetWorkout.Program.user_id != final_user_id) {
    throw new GraphQLError("You are not authorized to access this workout", {
      extensions: {
        code: "FORBIDDEN",
      },
    });
  }
}

/**
 * Enforces that an exercise exists identified by @workout_id
 *
 */
export async function checkExerciseExists({
  context,
  exercise_name,
}: {
  context: AppContext;
  exercise_name: string;
}) {
  const prisma = context.dataSources.prisma;
  const exercise = await prisma.excercise.findUnique({
    where: {
      excercise_name: exercise_name,
    },
  });
  if (exercise == null) {
    throw new GraphQLError("No exercise found");
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
/*COACH*/
/////presets
export function formatPresetExcerciseSetGroupsIntoPresetMutationReq(
  presetExcerciseSetGroups: PresetExcerciseSetGroupInput[]
) {
  const formattedData = presetExcerciseSetGroups.map(function (
    excerciseSetGroup
  ) {
    const { preset_excercise_sets, excercise_name } = excerciseSetGroup;
    return {
      excercise: {
        connect: {
          excercise_name: excercise_name,
        },
      },
      preset_excercise_sets: {
        create: preset_excercise_sets as PresetExcerciseSetInput[],
      },
    };
  });
  return formattedData;
}

export function formatPresetWorkoutsIntoPresetMutationReq(
  presetWorkouts: PresetWorkoutInput[]
) {
  const formattedData = presetWorkouts.map(function (workoutGroup) {
    const { rest_day, preset_excercise_set_groups } = workoutGroup;
    return {
      rest_day,
      preset_excercise_set_groups: {
        create: formatPresetExcerciseSetGroupsIntoPresetMutationReq(
          preset_excercise_set_groups
        ),
      },
    };
  });
  return formattedData;
}

export function convertPresetIntoExcerciseSetGroups(
  presetExcerciseSetGroups: PresetExcerciseSetGroup[]
) {
  const formattedData = presetExcerciseSetGroups.map(function (
    excerciseSetGroup
  ) {
    const { preset_excercise_sets, excercise_name } = excerciseSetGroup;
    return {
      excercise: {
        connect: {
          excercise_name: excercise_name,
        },
      },
      excercise_set_group_state: ExcerciseSetGroupState.NormalOperation,
      // this field only works because preset excercise sets works as an interface for excerciseSetInput <--- might want to look at a better solution here
      excercise_sets: {
        create: preset_excercise_sets.map(function (excerciseSet) {
          const { target_reps, target_weight } = excerciseSet;
          return {
            target_reps: target_reps,
            target_weight: target_weight,
          };
        }),
      },
    };
  });
  return formattedData;
}
