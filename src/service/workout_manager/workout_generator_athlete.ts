import {
  Equipment,
  ExcerciseMechanics,
  MuscleRegionType,
  PrismaClient,
  User,
  Workout,
} from "@prisma/client";
import { getActiveWorkoutCount } from "./workout_manager";
const _ = require("lodash");
const workout_name_list: string[] = ["lower 1", "upper", "lower 2"];
// issue 1: hips and calves might not have been available yet
const rotations_type: MuscleRegionType[][] = [
  //lower
  [
    //preparation
    MuscleRegionType.THIGHS,
    MuscleRegionType.THIGHS,
    MuscleRegionType.THIGHS,
    //main
    MuscleRegionType.THIGHS,
    MuscleRegionType.THIGHS,
    MuscleRegionType.THIGHS,
    //accessory
    MuscleRegionType.THIGHS,
    MuscleRegionType.THIGHS,
  ],
  //upper
  [
    MuscleRegionType.WAIST,
    MuscleRegionType.WAIST,
    MuscleRegionType.CHEST,
    MuscleRegionType.BACK,
    MuscleRegionType.SHOULDER,
    MuscleRegionType.CHEST,
    MuscleRegionType.UPPER_ARM,
    MuscleRegionType.BACK,
  ],
  //2nd lower
  [
    //preparation
    MuscleRegionType.THIGHS,
    MuscleRegionType.THIGHS,
    MuscleRegionType.THIGHS,
    //main
    MuscleRegionType.THIGHS,
    MuscleRegionType.THIGHS,
    MuscleRegionType.THIGHS,
    //accessory
    MuscleRegionType.THIGHS,
    MuscleRegionType.THIGHS,
  ],
];

//prep -> 2-3
//main -> 2-3
//accessory -> 1-2
export const workoutGeneratorAthlete = async (
  numberOfWorkouts: Number,
  context: any
) => {
  const prisma: PrismaClient = context.dataSources.prisma;
  const user: User = context.user;
  
  if (numberOfWorkouts > 6) {
    throw Error("Can only generate 6 workouts maximum.");
  }
  const generated_workout_list: Workout[] = [];
  const user_constaints = _.differenceWith(
    Object.keys(Equipment),
    user.equipment_accessible,
    _.isEqual
  );
  // Outer-loop is to create the workouts
  let list_of_excercises = [];
  let lower_1_rotation = await excercise_query(
    rotations_type[0],
    user_constaints,
    prisma,
    user,
    context,
    numberOfWorkouts
  );
  let upper_rotation = await excercise_query(
    rotations_type[1],
    user_constaints,
    prisma,
    user,
    context,
    numberOfWorkouts
  );
  let lower_2_rotation = await excercise_query(
    rotations_type[2],
    user_constaints,
    prisma,
    user,
    context,
    numberOfWorkouts
  );
  let createdWorkout;
  switch (numberOfWorkouts) {
    case 1:
            createdWorkout = await prisma.workout.create({
              data: {
                workout_name: workout_name_list[0],
                order_index: await getActiveWorkoutCount(context),
                user_id: user.user_id,
                life_span: 12,
                excercise_set_groups: { create: lower_1_rotation },
              },
              include: {
                excercise_set_groups: true,
              },
            });
            generated_workout_list.push(createdWorkout);
      break;
    case 2:
      for (let day = 0; day < numberOfWorkouts; day++) {
        switch (day) {
          case 0:
            createdWorkout = await prisma.workout.create({
              data: {
                workout_name: workout_name_list[0],
                order_index: await getActiveWorkoutCount(context),
                user_id: user.user_id,
                life_span: 12,
                excercise_set_groups: { create: lower_1_rotation },
              },
              include: {
                excercise_set_groups: true,
              },
            });

            generated_workout_list.push(createdWorkout);
            break;
              case 1:
                createdWorkout = await prisma.workout.create({
                  data: {
                    workout_name: workout_name_list[1],
                    order_index: await getActiveWorkoutCount(context),
                    user_id: user.user_id,
                    life_span: 12,
                    excercise_set_groups: { create: upper_rotation },
                  },
                  include: {
                    excercise_set_groups: true,
                  },
                });
                generated_workout_list.push(createdWorkout);
                break;
          default:
        }
      }
      break;
    case 3:
      for (let day = 0; day < numberOfWorkouts; day++) {
        switch (day) {
          case 0:
            createdWorkout = await prisma.workout.create({
              data: {
                workout_name: workout_name_list[0],
                order_index: await getActiveWorkoutCount(context),
                user_id: user.user_id,
                life_span: 12,
                excercise_set_groups: { create: lower_1_rotation },
              },
              include: {
                excercise_set_groups: true,
              },
            });
            generated_workout_list.push(createdWorkout);
            break;
          case 1:
            createdWorkout = await prisma.workout.create({
              data: {
                workout_name: workout_name_list[1],
                order_index: await getActiveWorkoutCount(context),
                user_id: user.user_id,
                life_span: 12,
                excercise_set_groups: { create: upper_rotation },
              },
              include: {
                excercise_set_groups: true,
              },
            });
            generated_workout_list.push(createdWorkout);
            break;
          case 2:
            createdWorkout = await prisma.workout.create({
              data: {
                workout_name: workout_name_list[0],
                order_index: await getActiveWorkoutCount(context),
                user_id: user.user_id,
                life_span: 12,
                excercise_set_groups: { create: lower_1_rotation },
              },
              include: {
                excercise_set_groups: true,
              },
            });
            generated_workout_list.push(createdWorkout);
            break;
          default:
        }
      }
      break;
    case 4:
      for (let day = 0; day < numberOfWorkouts; day++) {
        switch (day) {
          case 0:
            createdWorkout = await prisma.workout.create({
              data: {
                workout_name: workout_name_list[0],
                order_index: await getActiveWorkoutCount(context),
                user_id: user.user_id,
                life_span: 12,
                excercise_set_groups: { create: lower_1_rotation },
              },
              include: {
                excercise_set_groups: true,
              },
            });
            generated_workout_list.push(createdWorkout);
            break;
          case 1:
            createdWorkout = await prisma.workout.create({
              data: {
                workout_name: workout_name_list[1],
                order_index: await getActiveWorkoutCount(context),
                user_id: user.user_id,
                life_span: 12,
                excercise_set_groups: { create: upper_rotation },
              },
              include: {
                excercise_set_groups: true,
              },
            });
            generated_workout_list.push(createdWorkout);
            break;
          case 2:
            createdWorkout = await prisma.workout.create({
              data: {
                workout_name: workout_name_list[0],
                order_index: await getActiveWorkoutCount(context),
                user_id: user.user_id,
                life_span: 12,
                excercise_set_groups: { create: lower_1_rotation },
              },
              include: {
                excercise_set_groups: true,
              },
            });
            generated_workout_list.push(createdWorkout);
            break;
          case 3:
            createdWorkout = await prisma.workout.create({
              data: {
                workout_name: workout_name_list[1],
                order_index: await getActiveWorkoutCount(context),
                user_id: user.user_id,
                life_span: 12,
                excercise_set_groups: { create: upper_rotation },
              },
              include: {
                excercise_set_groups: true,
              },
            });
            generated_workout_list.push(createdWorkout);
            break;
          default:
        }
      }
      break;
    case 5:
      for (let day = 0; day < numberOfWorkouts; day++) {
        switch (day) {
          case 0:
            createdWorkout = await prisma.workout.create({
              data: {
                workout_name: workout_name_list[0],
                order_index: await getActiveWorkoutCount(context),
                user_id: user.user_id,
                life_span: 12,
                excercise_set_groups: { create: lower_1_rotation },
              },
              include: {
                excercise_set_groups: true,
              },
            });
            generated_workout_list.push(createdWorkout);
            break;
          case 1:
            createdWorkout = await prisma.workout.create({
              data: {
                workout_name: workout_name_list[1],
                order_index: await getActiveWorkoutCount(context),
                user_id: user.user_id,
                life_span: 12,
                excercise_set_groups: { create: upper_rotation },
              },
              include: {
                excercise_set_groups: true,
              },
            });
            generated_workout_list.push(createdWorkout);
            break;
          case 2:
            createdWorkout = await prisma.workout.create({
              data: {
                workout_name: workout_name_list[2],
                order_index: await getActiveWorkoutCount(context),
                user_id: user.user_id,
                life_span: 12,
                excercise_set_groups: { create: lower_2_rotation },
              },
              include: {
                excercise_set_groups: true,
              },
            });
            generated_workout_list.push(createdWorkout);
            break;
          case 3:
            createdWorkout = await prisma.workout.create({
              data: {
                workout_name: workout_name_list[0],
                order_index: await getActiveWorkoutCount(context),
                user_id: user.user_id,
                life_span: 12,
                excercise_set_groups: { create: lower_1_rotation },
              },
              include: {
                excercise_set_groups: true,
              },
            });
            generated_workout_list.push(createdWorkout);
            break;
          case 4:
            createdWorkout = await prisma.workout.create({
              data: {
                workout_name: workout_name_list[1],
                order_index: await getActiveWorkoutCount(context),
                user_id: user.user_id,
                life_span: 12,
                excercise_set_groups: { create: upper_rotation },
              },
              include: {
                excercise_set_groups: true,
              },
            });
            generated_workout_list.push(createdWorkout);
            break;
          default:
        }
      }
      break;
    case 6:
      for (let day = 0; day < numberOfWorkouts; day++) {
        switch (day) {
          case 0:
            createdWorkout = await prisma.workout.create({
              data: {
                workout_name: workout_name_list[0],
                order_index: await getActiveWorkoutCount(context),
                user_id: user.user_id,
                life_span: 12,
                excercise_set_groups: { create: lower_1_rotation },
              },
              include: {
                excercise_set_groups: true,
              },
            });
            generated_workout_list.push(createdWorkout);
            break;
          case 1:
            createdWorkout = await prisma.workout.create({
              data: {
                workout_name: workout_name_list[2],
                order_index: await getActiveWorkoutCount(context),
                user_id: user.user_id,
                life_span: 12,
                excercise_set_groups: { create: lower_2_rotation },
              },
              include: {
                excercise_set_groups: true,
              },
            });
            generated_workout_list.push(createdWorkout);
            break;
          case 2:
            createdWorkout = await prisma.workout.create({
              data: {
                workout_name: workout_name_list[1],
                order_index: await getActiveWorkoutCount(context),
                user_id: user.user_id,
                life_span: 12,
                excercise_set_groups: { create: upper_rotation },
              },
              include: {
                excercise_set_groups: true,
              },
            });
            generated_workout_list.push(createdWorkout);
            break;
          case 3:
            createdWorkout = await prisma.workout.create({
              data: {
                workout_name: workout_name_list[0],
                order_index: await getActiveWorkoutCount(context),
                user_id: user.user_id,
                life_span: 12,
                excercise_set_groups: { create: lower_1_rotation },
              },
              include: {
                excercise_set_groups: true,
              },
            });
            generated_workout_list.push(createdWorkout);
            break;
          case 4:
            createdWorkout = await prisma.workout.create({
              data: {
                workout_name: workout_name_list[2],
                order_index: await getActiveWorkoutCount(context),
                user_id: user.user_id,
                life_span: 12,
                excercise_set_groups: { create: lower_2_rotation },
              },
              include: {
                excercise_set_groups: true,
              },
            });
            generated_workout_list.push(createdWorkout);
            break;
          case 5:
            createdWorkout = await prisma.workout.create({
              data: {
                workout_name: workout_name_list[1],
                order_index: await getActiveWorkoutCount(context),
                user_id: user.user_id,
                life_span: 12,
                excercise_set_groups: { create: upper_rotation },
              },
              include: {
                excercise_set_groups: true,
              },
            });
            generated_workout_list.push(createdWorkout);
            break;
          default:
        }
      }
      break;
    default:
  }

  return generated_workout_list;
};
//function to create exercise list to be inserted into the DB (for each workout)
const excercise_query = async (
  rotation: MuscleRegionType[],
  user_constaints: any,
  prisma: PrismaClient,
  user: User,
  context: any,
  numberOfWorkouts: Number
) => {
  let list_of_excercises = [];
  if (numberOfWorkouts>5) {
    for (let exercise_index = 0; exercise_index < 5; exercise_index++) {
      if (exercise_index < 2) {
        const excercises_in_category = await prisma.excercise.findMany({
          where: {
            body_weight: true,
            target_regions: {
              some: {
                muscle_region_type: rotation[exercise_index],
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
            assisted: false,
          },
        });
        if (excercises_in_category.length > 0) {
          var randomSelectedExcercise =
            excercises_in_category[
              Math.floor(Math.random() * excercises_in_category.length)
            ];
          list_of_excercises.push(
            await formatAndGenerateExcerciseSets(
              randomSelectedExcercise,
              rotation[exercise_index],
              context
            )
          );
        }
      } else if (exercise_index < 4) {
        const excercises_in_category = await prisma.excercise.findMany({
          where: {
            excercise_mechanics: {
              has: ExcerciseMechanics.COMPOUND,
            },
            target_regions: {
              some: {
                muscle_region_type: rotation[exercise_index],
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
          var randomSelectedExcercise =
            excercises_in_category[
              Math.floor(Math.random() * excercises_in_category.length)
            ];
          list_of_excercises.push(
            await formatAndGenerateExcerciseSets(
              randomSelectedExcercise,
              rotation[exercise_index],
              context
            )
          );
        }
      } else {
        const excercises_in_category = await prisma.excercise.findMany({
          where: {
            excercise_mechanics: {
              has: ExcerciseMechanics.ISOLATED,
            },
            target_regions: {
              some: {
                muscle_region_type: rotation[exercise_index],
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
          var randomSelectedExcercise =
            excercises_in_category[
              Math.floor(Math.random() * excercises_in_category.length)
            ];
          list_of_excercises.push(
            await formatAndGenerateExcerciseSets(
              randomSelectedExcercise,
              rotation[exercise_index],
              context
            )
          );
        }
      }
    }
  } else {
    for (
      let exercise_index = 0;
      exercise_index < rotation.length;
      exercise_index++
    ) {
      if (exercise_index < 3) {
        const excercises_in_category = await prisma.excercise.findMany({
          where: {
            body_weight: true,
            target_regions: {
              some: {
                muscle_region_type: rotation[exercise_index],
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
            assisted: false,
          },
        });
        if (excercises_in_category.length > 0) {
          var randomSelectedExcercise =
            excercises_in_category[
              Math.floor(Math.random() * excercises_in_category.length)
            ];
          list_of_excercises.push(
            await formatAndGenerateExcerciseSets(
              randomSelectedExcercise,
              rotation[exercise_index],
              context
            )
          );
        }
      } else if (exercise_index < 6) {
        const excercises_in_category = await prisma.excercise.findMany({
          where: {
            excercise_mechanics: {
              has: ExcerciseMechanics.COMPOUND,
            },
            target_regions: {
              some: {
                muscle_region_type: rotation[exercise_index],
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
          var randomSelectedExcercise =
            excercises_in_category[
              Math.floor(Math.random() * excercises_in_category.length)
            ];
          list_of_excercises.push(
            await formatAndGenerateExcerciseSets(
              randomSelectedExcercise,
              rotation[exercise_index],
              context
            )
          );
        }
      } else {
        const excercises_in_category = await prisma.excercise.findMany({
          where: {
            excercise_mechanics: {
              has: ExcerciseMechanics.ISOLATED,
            },
            target_regions: {
              some: {
                muscle_region_type: rotation[exercise_index],
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
          var randomSelectedExcercise =
            excercises_in_category[
              Math.floor(Math.random() * excercises_in_category.length)
            ];
          list_of_excercises.push(
            await formatAndGenerateExcerciseSets(
              randomSelectedExcercise,
              rotation[exercise_index],
              context
            )
          );
        }
      }
    }
  }
  return list_of_excercises;
};

const formatAndGenerateExcerciseSets = async (
  excercise,
  type: String,
  context: any
) => {
  const prisma = context.dataSources.prisma;
  const user = context.user;

  let excercise_sets;
  // Checks if there is previous data, will use that instead
  var previousExcerciseSetGroup = await prisma.excerciseSetGroup.findFirst({
    where: {
      excercise_name: excercise.excercise_name,
      workout: {
        user_id: user.user_id,
        date_completed: { not: null },
      },
    },
    include: {
      excercise_sets: true,
    },
  });

  if (previousExcerciseSetGroup != null) {
    excercise_sets = previousExcerciseSetGroup.excercise_sets;
  } else {
    // No previous data, so we use the default values
    let targetWeight;
    let targetReps;
    if (
      excercise.body_weight == false &&
      excercise.excercise_mechanics == ExcerciseMechanics.COMPOUND
    ) {
      // Compound non-body weight excercises
      targetWeight = 0;
      targetReps = user.compound_movement_rep_lower_bound;
    } else if (
      excercise.body_weight == false &&
      excercise.excercise_mechanics == ExcerciseMechanics.ISOLATED
    ) {
      // Isolated non-body weight excercises
      targetWeight = 0;
      targetReps = user.isolated_movement_rep_lower_bound;
    } else if (
      excercise.body_weight == true &&
      excercise.excercise_mechanics == ExcerciseMechanics.ISOLATED
    ) {
      // body-weight, isolated excercise
      targetWeight = 0;
      targetReps = user.isolated_movement_rep_lower_bound;
    } else if (
      excercise.body_weight == true &&
      excercise.excercise_mechanics == ExcerciseMechanics.COMPOUND
    ) {
      // body-weight, compound excercise
      targetWeight = 0;
      targetReps = user.compound_movement_rep_lower_bound;
    }
    excercise_sets = new Array(5).fill({
      target_weight: targetWeight,
      weight_unit: "KG",
      target_reps: targetReps,
      actual_weight: null,
      actual_reps: null,
    });
  }

  return {
    excercise_name: excercise.excercise_name,
    excercise_set_group_state: "NORMAL_OPERATION",
    excercise_sets: { create: excercise_sets },
  };
};
