import { AppContext } from "../../../types/contextType";
import {
  MuscleRegionType,
  Excercise,
  ExcerciseSetGroupState,
} from "../../../types/graphql";
import { workout_name_list } from "./constants";
import {
  formatAndGenerateExcerciseSets,
  formatExcerciseSetGroups,
} from "../utils";
import { progressivelyOverload } from "../progressive_overloader/progressive_overloader";
import _ from "lodash";
import * as workoutSplit from "./rotations_types_general";
import { GraphQLError } from "graphql";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import {
  PrismaExerciseSetGroupCreateArgs,
  WorkoutWithExerciseSets,
} from "../../../types/Prisma";
import { DayOfWeek, Prisma, ProgramType } from "@prisma/client";
import { Equipment } from "@prisma/client";
/**
 * Generator V2.
 */
export const workoutGeneratorV2 = async (
  daysOfWeek: DayOfWeek[],
  context: AppContext,
  program_id?: number
) => {
  onlyAuthenticated(context);

  const user = context.base_user!.User!;
  const prisma = context.dataSources.prisma;

  // guard clause
  if (daysOfWeek.length > 6) {
    throw new GraphQLError("Can only generate 6 workouts maximum per week.");
  }
  if (daysOfWeek.length < 2) {
    throw new GraphQLError("A minimum of 2 workouts per week.");
  }

  const create_workout_args_list: Omit<
    Prisma.WorkoutUncheckedCreateInput,
    "program_id" | "programProgram_id"
  >[] = [];

  // Contains a list of equipment that the user has NO access to.
  const user_constaints = _.differenceWith(
    Object.keys(Equipment),
    user.equipment_accessible,
    _.isEqual
  ) as Equipment[];
  // The name selector cannot be random

  // excercise_pointer used with randomRotation determines which exercise type should be next
  let rotationSequenceMuscle: MuscleRegionType[][] = [[]];
  switch (daysOfWeek.length) {
    case 2:
      rotationSequenceMuscle = workoutSplit.twoDaySplitMuscle;
      break;
    case 3:
      rotationSequenceMuscle = workoutSplit.threeDaySplitMuscle;
      break;
    case 4:
      rotationSequenceMuscle = workoutSplit.fourDaySplitMuscle;
      break;
    case 5:
      rotationSequenceMuscle = workoutSplit.fiveDaySplit;
      break;
    case 6:
      rotationSequenceMuscle = workoutSplit.sixDaySplit;
  }
  // Core logic
  let Rotation: MuscleRegionType[] = [];
  let max = 0;

  for (let day = 0; day < daysOfWeek.length; day++) {
    const list_of_excercises: any = [];
    Rotation = rotationSequenceMuscle[day];
    if (daysOfWeek.length > 5) {
      max = Rotation.length - 1; // 1 less exercise per day if days is more than 5
    } else {
      max = Rotation.length;
    }
    for (let excercise_index = 0; excercise_index < max; excercise_index++) {
      const excercises_in_category = await prisma.excercise.findMany({
        where: {
          target_regions: {
            some: {
              muscle_region_type: Rotation[excercise_index],
            },
          },
          NOT: {
            equipment_required: {
              hasSome: user_constaints,
            },
          },
          body_weight: !(user.equipment_accessible.length > 0), // use body weight excercise if don't have accessible equipments
          assisted: false,
        },
      });
      if (excercises_in_category.length > 0) {
        const randomSelectedExcercise: Excercise = _.sample(
          excercises_in_category
        )!;
        const exerciseSetCreateArgs: any = await formatAndGenerateExcerciseSets(
          randomSelectedExcercise.excercise_name,
          context
        );
        list_of_excercises.push(exerciseSetCreateArgs);
      }
    }
    const createdWorkoutArgs: Omit<
      Prisma.WorkoutUncheckedCreateInput,
      "program_id" | "programProgram_id"
    > = {
      dayOfWeek: daysOfWeek[day],
      workout_name: _.sample(workout_name_list)!,
      excercise_set_groups: { create: list_of_excercises },
    };
    create_workout_args_list.push(createdWorkoutArgs);
  }
  const newProgram = await prisma.$transaction(async (tx) => {
    let program_id_to_use: number;
    if (program_id) {
      program_id_to_use = program_id;
    } else {
      const newProgram = await tx.program.create({
        data: {
          program_type: ProgramType.AI_MANAGED,
          user_id: user.user_id,
        },
      });
      program_id_to_use = newProgram.program_id;
    }
    await Promise.all(
      create_workout_args_list.map(async (workoutData) => {
        await tx.workout.create({
          data: {
            programProgram_id: program_id_to_use,
            ...workoutData,
          },
        });
      })
    );
    return await tx.program.findUnique({
      where: {
        program_id: program_id_to_use,
      },
      include: {
        workouts: {
          include: {
            excercise_set_groups: {
              include: {
                excercise_sets: true,
              },
            },
          },
        },
      },
    });
  });
  if (!newProgram) {
    throw new GraphQLError("Could not create program");
  }
  return newProgram;
};

/**
 * Generates the next workout, using the previousWorkout parameter as the base.
 * Note: This function is only called when a workout has been completed.
 */
export async function generateNextWorkout(
  context: AppContext,
  previousWorkout: WorkoutWithExerciseSets,
  next_workout_excercise_set_groups: PrismaExerciseSetGroupCreateArgs[]
) {
  const prisma = context.dataSources.prisma;
  const { workout_name, excercise_set_groups, programProgram_id, dayOfWeek } =
    previousWorkout;
  const previousExerciseSetGroups = excercise_set_groups;
  const program = await prisma.program.findUniqueOrThrow({
    where: { program_id: programProgram_id },
  });
  if (program.program_type !== ProgramType.AI_MANAGED) {
    throw Error("Must be of Ai Managed");
  }
  if (previousWorkout.date_closed) {
    // Do not generate next workout if it's within one week of ending date
  }
  if (program.ending_date) {
    // refresh workouts
  }
  // Overload the workout
  // Don't need progressive overload because it was NOT completed in previous workout (It was temporarily replaced or removed)
  const excercise_set_groups_without_progressive_overload: PrismaExerciseSetGroupCreateArgs[] =
    _.differenceWith(
      next_workout_excercise_set_groups,
      previousExerciseSetGroups,
      (x, y) => x.excercise_name === y.excercise_name
    );
  // Need progressive overload because it was completed in the previous workout
  const excercise_set_groups_to_progressive_overload: PrismaExerciseSetGroupCreateArgs[] =
    _.differenceWith(
      next_workout_excercise_set_groups,
      excercise_set_groups_without_progressive_overload,
      (x, y) => x.excercise_name === y.excercise_name
    );
  const progressively_overloaded_excercise_set_groups =
    await progressivelyOverload(
      excercise_set_groups_to_progressive_overload,
      context
    );
  // Combine the excerciseSetGroups together and set them to back to normal operation
  const finalExcerciseSetGroups =
    excercise_set_groups_without_progressive_overload
      .concat(progressively_overloaded_excercise_set_groups)
      .map((e) => ({
        ...e,
        excercise_set_group_state: ExcerciseSetGroupState.NormalOperation,
      }));
  // Create the workout.
  const formated = formatExcerciseSetGroups(finalExcerciseSetGroups);
  await prisma.workout.create({
    data: {
      workout_name: workout_name,
      programProgram_id: program.program_id,
      dayOfWeek: dayOfWeek,
      excercise_set_groups: {
        create: formated,
      },
    },
  });
}
