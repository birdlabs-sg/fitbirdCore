import {
  Equipment,
  Excercise,
  ExcerciseMechanics,
  MuscleRegionType,
  PrismaClient,
  User,
  Workout,
} from "@prisma/client";
import {
  generateExerciseMetadata,
  generateOrUpdateExcerciseMetadata,
  getActiveWorkoutCount,
} from "./workout_manager";
const _ = require("lodash");

const rotations_type: MuscleRegionType[][] = [
  [
    MuscleRegionType.THIGHS,
    MuscleRegionType.CHEST,
    MuscleRegionType.BACK,
    MuscleRegionType.SHOULDER,
    MuscleRegionType.UPPER_ARM,
  ],
  [
    MuscleRegionType.BACK,
    MuscleRegionType.CHEST,
    MuscleRegionType.SHOULDER,
    MuscleRegionType.THIGHS,
    MuscleRegionType.UPPER_ARM,
  ],
  [
    MuscleRegionType.CHEST,
    MuscleRegionType.BACK,
    MuscleRegionType.SHOULDER,
    MuscleRegionType.THIGHS,
    MuscleRegionType.UPPER_ARM,
  ],
];

export const workoutGenerator = async (
  numberOfWorkouts: Number,
  context: any
) => {
  const prisma: PrismaClient = context.dataSources.prisma;
  const user: User = context.user;

  const workout_name_list: string[] = [
    "Sexy Sparrow",
    "Odd Osprey",
    "Dangerous Dove",
    "Perky Pigeon",
    "Elated Eagle",
    "Kind King-fisher",
    "Seagull",
    "Ominous Owl",
    "Peaceful Parakeet",
    "Crazy Cuckoo",
    "Wacky Woodpecker",
    "Charming Canary",
  ];

  // guard clause
  if (numberOfWorkouts > 7) {
    throw Error("Can only generate 7 workouts maximum.");
  }
  const generated_workout_list: Workout[] = [];

  // Contains a list of equipment that the user has NO access to.
  const user_constaints = _.differenceWith(
    Object.keys(Equipment),
    user.equipment_accessible,
    _.isEqual
  );

  // Randomly select a rotation plan for the requestor
  const randomRotation: MuscleRegionType[] =
    rotations_type[Math.floor(Math.random() * rotations_type.length)];

  // excercise_pointer used with randomRotation determines which exercise type should be next
  var excercise_pointer = 0;

  // Core logic
  for (let day = 0; day < numberOfWorkouts; day++) {
    // Outer-loop is to create the workouts
    let list_of_excercises = [];
    for (let excercise_index = 0; excercise_index < 4; excercise_index++) {
      // inner-loop is to create each workout.
      // Each workout will have 5 excercises. First 3 follows the rotation_type in a round robin fashion
      // Last 2 are waist excercises (ABS)
      if (excercise_pointer > randomRotation.length - 1) {
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
        const excercise_1 = waist_excercise.splice(
          Math.floor(Math.random() * waist_excercise.length),
          1
        )[0];
        const excercise_2 = waist_excercise.splice(
          Math.floor(Math.random() * waist_excercise.length),
          1
        )[0];
        list_of_excercises.push(
          await formatAndGenerateExcerciseSets(excercise_1, "WAIST", context)
        );
        list_of_excercises.push(
          await formatAndGenerateExcerciseSets(excercise_2, "WAIST", context)
        );
      } else {
        // insert excercises from rotation_type in a order for iteration 1,2,3
        const excercises_in_category = await prisma.excercise.findMany({
          where: {
            target_regions: {
              some: {
                muscle_region_type: randomRotation[excercise_pointer],
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
              randomRotation[excercise_pointer],
              context
            )
          );
        }
        excercise_pointer++;
      }
    }
    let createdWorkout;
    // create workout and generate the associated excercisemetadata
    try {
      createdWorkout = await prisma.workout.create({
        data: {
          workout_name: workout_name_list.splice(
            (Math.random() * workout_name_list.length) | 0,
            1
          )[0],
          order_index: await getActiveWorkoutCount(context),
          user_id: user.user_id,
          life_span: 12,
          excercise_set_groups: { create: list_of_excercises },
        },
        include: {
          excercise_set_groups: true,
        },
      });
    } catch (e) {
      console.log(e);
    }

    // push the result ot the list
    generated_workout_list.push(createdWorkout);
  }
  return generated_workout_list;
};

const formatAndGenerateExcerciseSets = async (
  excercise: Excercise,
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
  generateExerciseMetadata(context, excercise.excercise_name);
  if (previousExcerciseSetGroup != null) {
    excercise_sets = previousExcerciseSetGroup.excercise_sets;
    excercise_sets.forEach((element) => {
      delete element["excercise_set_group_id"];
      delete element["excercise_set_id"];
      element["actual_reps"] = null;
      element["actual_weight"] = null;
    });
  } else {
    // No previous data
    excercise_sets = new Array(5).fill({
      target_weight: 0,
      weight_unit: "KG",
      target_reps: 0,
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
