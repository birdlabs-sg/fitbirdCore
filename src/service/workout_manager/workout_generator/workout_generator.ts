import { AppContext } from "../../../types/contextType";
import {
  MuscleRegionType,
  Excercise,
  ExcerciseSetGroupState,
} from "../../../types/graphql";
import {
  PrismaExerciseSetGroupCreateArgs,
  WorkoutWithExerciseSets,
} from "../../../types/Prisma";
import { rotations_type, workout_name_list } from "./constants";
import {
  formatAndGenerateExcerciseSets,
  formatExcerciseSetGroups,
  getActiveWorkoutCount,
} from "../utils";
import { progressivelyOverload } from "../progressive_overloader/progressive_overloader";
import { Equipment, WorkoutType } from "@prisma/client";
const _ = require("lodash");
import * as workoutSplit from "./rotations_types_general";
/**
 * Generates a list of workouts (AKA a single rotation) based on requestors's equipment constraints.
 */
export const workoutGenerator = async (
  numberOfWorkouts: Number,
  context: AppContext
) => {
  const prisma = context.dataSources.prisma;
  const user = context.user;

  // guard clause
  if (numberOfWorkouts > 6) {
    throw Error("Can only generate 6 workouts maximum.");
  }
  const generated_workout_list: WorkoutWithExerciseSets[] = [];

  // Contains a list of equipment that the user has NO access to.
  const user_constaints = _.differenceWith(
    Object.keys(Equipment),
    user.equipment_accessible,
    _.isEqual
  );

  // Randomly select a rotation plan for the requestor
  const random_rotation: MuscleRegionType[] = _.sample(rotations_type);

  // excercise_pointer used with randomRotation determines which exercise type should be next
  var excercise_pointer = 0;

  // Core logic
  for (let day = 0; day < numberOfWorkouts; day++) {
    // Outer-loop is to create the workouts
    const list_of_excercise_set_groups = [];
    for (let excercise_index = 0; excercise_index < 4; excercise_index++) {
      // inner-loop is to create each workout.
      // Each workout will have 5 excercises. First 3 follows the rotation_type in a round robin fashion
      // Last 2 are waist excercises (ABS)
      if (excercise_pointer > random_rotation.length - 1) {
        // Reset the pointer so that it goes in a round robin fashion
        excercise_pointer = 0;
      }
      if (excercise_index == 3) {
        // insert waist excercise on the 4th and 5th iteration
        const waist_excercise = await prisma.excercise.findMany({
          where: {
            target_regions: {
              some: { muscle_region_type: "WAIST" },
            },
            NOT: {
              equipment_required: {
                hasSome: user_constaints,
              },
            },
            excercise_utility: {
              has: "BASIC",
            },
            body_weight: true,
            assisted: false,
          },
        });
        // Pick 2 waist excercises from the returned list at random with no repeats.
        const [excercise_1, excercise_2]: Excercise[] = _.sampleSize(
          waist_excercise,
          2
        );
        list_of_excercise_set_groups.push(
          await formatAndGenerateExcerciseSets(
            excercise_1.excercise_name,
            context
          )
        );
        list_of_excercise_set_groups.push(
          await formatAndGenerateExcerciseSets(
            excercise_2.excercise_name,
            context
          )
        );
      } else {
        // insert excercises from rotation_type in a order for iteration 1,2,3
        const excercises_in_category = await prisma.excercise.findMany({
          where: {
            target_regions: {
              some: {
                muscle_region_type: random_rotation[excercise_pointer],
              },
            },
            NOT: {
              equipment_required: {
                hasSome: user_constaints,
              },
            },
            excercise_utility: {
              has: "BASIC",
            },
            body_weight: !(user.equipment_accessible.length > 0), // use body weight excercise if don't have accessible equipments
            assisted: false,
          },
        });

        if (excercises_in_category.length > 0) {
          const random_exercise: Excercise = _.sample(excercises_in_category);
          list_of_excercise_set_groups.push(
            await formatAndGenerateExcerciseSets(
              random_exercise.excercise_name,
              context
            )
          );
        }
        excercise_pointer++;
      }
    }
    // create workout and generate the associated excercisemetadata
    const createdWorkout = await prisma.workout.create({
      data: {
        workout_name: _.sample(workout_name_list),
        order_index: await getActiveWorkoutCount(
          context,
          WorkoutType.AI_MANAGED
        ),
        user_id: user.user_id,
        life_span: user.ai_managed_workouts_life_cycle,
        excercise_set_groups: { create: list_of_excercise_set_groups },
        workout_type: WorkoutType.AI_MANAGED,
      },
      include: {
        excercise_set_groups: { include: { excercise_sets: true } },
      },
    });
    // push the result ot the list
    generated_workout_list.push(createdWorkout);
  }
  return generated_workout_list;
};

/**
 * Generator V2.
 */
export const workoutGeneratorV2 = async (
  numberOfWorkouts: Number,
  context: any
) => {
  const prisma = context.dataSources.prisma;
  const user = context.user;

  // guard clause
  if (numberOfWorkouts > 6) {
    throw Error("Can only generate 6 workouts maximum per week.");
  }
  if (numberOfWorkouts < 2) {
    throw Error("A minimum of 2 workouts per week.");
  }

  const generated_workout_list: WorkoutWithExerciseSets[] = [];

  // Contains a list of equipment that the user has NO access to.
  const user_constaints = _.differenceWith(
    Object.keys(Equipment),
    user.equipment_accessible,
    _.isEqual
  );
  // The name selector cannot be random

  // excercise_pointer used with randomRotation determines which exercise type should be next
  let rotationSequenceMuscle: MuscleRegionType[][] = [[]];
  switch (numberOfWorkouts) {
    case 2:
      rotationSequenceMuscle = workoutSplit.twoDaySplitMuscle;
    case 3:
      rotationSequenceMuscle = workoutSplit.threeDaySplitMuscle;
    case 4:
      rotationSequenceMuscle = workoutSplit.fourDaySplitMuscle;
    case 5:
      rotationSequenceMuscle = workoutSplit.fiveDaySplit;
    case 6:
      rotationSequenceMuscle = workoutSplit.sixDaySplit;
  }
  // Core logic
  await excerciseSelector(
    numberOfWorkouts,
    context,
    rotationSequenceMuscle,
    user_constaints,
    generated_workout_list
  );
  return generated_workout_list;
};

// re configured the selector to make it more usable among different exercise plans
const excerciseSelector = async (
  numberOfWorkouts: Number,
  context: AppContext,
  rotationSequence: MuscleRegionType[][] /*| ExcerciseForce[][]*/,
  user_constaints: Equipment[],
  generated_workout_list: WorkoutWithExerciseSets[]
) => {
  const prisma = context.dataSources.prisma;
  const user = context.user;
  let Rotation = [];
  let max = 0;

  for (let day = 0; day < numberOfWorkouts; day++) {
    let list_of_excercises = [];
    Rotation = rotationSequence[day];
    if (numberOfWorkouts > 5) {
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
        var randomSelectedExcercise: Excercise = _.sample(
          excercises_in_category
        );
        list_of_excercises.push(
          await formatAndGenerateExcerciseSets(
            randomSelectedExcercise.excercise_name,
            context
          )
        );
      }
    }
    const createdWorkout = await prisma.workout.create({
      data: {
        workout_name: _.sample(workout_name_list),
        order_index: await getActiveWorkoutCount(
          context,
          WorkoutType.AI_MANAGED
        ),
        user_id: user.user_id,
        life_span: user.ai_managed_workouts_life_cycle,
        excercise_set_groups: { create: list_of_excercises },
        workout_type: WorkoutType.AI_MANAGED,
      },
      include: {
        excercise_set_groups: {
          include: {
            excercise_sets: true,
          },
        },
      },
    });
    generated_workout_list.push(createdWorkout);
  }
  // create workout and generate the associated excercisemetadata
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
  const { life_span, workout_name, workout_type, excercise_set_groups } =
    previousWorkout;
  var previousExerciseSetGroups = excercise_set_groups;
  if (
    previousWorkout.life_span <= 0 &&
    previousWorkout.workout_type == WorkoutType.AI_MANAGED
  ) {
    // Build a new workout using the same exercisegroups
    const user_constaints = _.differenceWith(
      Object.keys(Equipment),
      context.user.equipment_accessible,
      _.isEqual
    );
    const list_of_excercise_set_groups = [];
    for (var exerciseSetGroup of previousExerciseSetGroups) {
      var previousExercise = await prisma.excercise.findUnique({
        where: {
          excercise_name: exerciseSetGroup.excercise_name,
        },
        include: {
          target_regions: true,
        },
      });

      var differentExercises = await prisma.excercise.findMany({
        where: {
          target_regions: {
            some: previousExercise.target_regions[0],
          },
          NOT: {
            excercise_name: previousExercise.excercise_name,
            equipment_required: {
              hasSome: user_constaints,
            },
          },
          body_weight: !(context.user.equipment_accessible.length > 0), // use body weight excercise if don't have accessible equipments
          assisted: false,
        },
      });
      var excercise = _.sample(differentExercises);
      list_of_excercise_set_groups.push(
        await formatAndGenerateExcerciseSets(excercise.excercise_name, context)
      );
      await prisma.workout.create({
        data: {
          workout_name: previousWorkout.workout_name,
          order_index: await getActiveWorkoutCount(
            context,
            WorkoutType.AI_MANAGED
          ),
          user_id: context.user.user_id,
          life_span: context.user.ai_managed_workouts_life_cycle,
          excercise_set_groups: { create: list_of_excercise_set_groups },
          workout_type: WorkoutType.AI_MANAGED,
        },
        include: {
          excercise_set_groups: { include: { excercise_sets: true } },
        },
      });
    }
  } else {
    // Don't need progressive overload because it was NOT completed in previous workout (It was temporarily replaced or removed)
    const excercise_set_groups_without_progressive_overload: PrismaExerciseSetGroupCreateArgs[] =
      _.differenceWith(
        next_workout_excercise_set_groups,
        previousExerciseSetGroups,
        (
          x: PrismaExerciseSetGroupCreateArgs,
          y: PrismaExerciseSetGroupCreateArgs
        ) => x.excercise_name === y.excercise_name
      );

    // Need progressive overload because it was completed in the previous workout
    const excercise_set_groups_to_progressive_overload: PrismaExerciseSetGroupCreateArgs[] =
      _.differenceWith(
        next_workout_excercise_set_groups,
        excercise_set_groups_without_progressive_overload,
        (
          x: PrismaExerciseSetGroupCreateArgs,
          y: PrismaExerciseSetGroupCreateArgs
        ) => x.excercise_name === y.excercise_name
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
    // Create the workout and slot behind the rest of the queue.
    await prisma.workout.create({
      data: {
        user_id: context.user.user_id,
        workout_name: workout_name!,
        life_span:
          workout_type == WorkoutType.SELF_MANAGED ? life_span : life_span! - 1, // Don't deduct life_span from SELF_MANAGED workouts
        order_index: await getActiveWorkoutCount(context, workout_type),
        workout_type: workout_type,
        excercise_set_groups: {
          create: formatExcerciseSetGroups(finalExcerciseSetGroups),
        },
      },
    });
  }
}
