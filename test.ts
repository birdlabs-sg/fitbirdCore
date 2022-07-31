const { PrismaClient } = require("@prisma/client");
// NOTE: haven't account for different format AKA the CARDIOexcercises, olmpic excercises etc.
const prisma = new PrismaClient();
const util = require("util");

const excercise_set_groups = [
  {
    excercise_name: "Lever Lying Leg Raise Crunch (plate loaded)",
    excercise_set_group_state: "NORMAL_OPERATION",
    excercise_sets: {
      create: [
        {
          target_weight: 80.0,
          weight_unit: "KG",
          target_reps: 15,
          actual_weight: 80.0,
          actual_reps: 12,
        },
        {
          target_weight: 80.0,
          weight_unit: "KG",
          target_reps: 15,
          actual_weight: 80.0,
          actual_reps: 12,
        },
      ],
    },
  },
];

var raw_excercise_set_groups = [
  {
    excercise_name: "Lever Lying Leg Raise Crunch (plate loaded)",
    excercise_set_group_state: "DELETED_PERMANANTLY",
    excercise_sets: [
      {
        target_weight: 80.0,
        weight_unit: "KG",
        target_reps: 15,
        actual_weight: 80.0,
        actual_reps: 12,
      },
      {
        target_weight: 80.0,
        weight_unit: "KG",
        target_reps: 15,
        actual_weight: 80.0,
        actual_reps: 12,
      },
    ],
  },
];

function formatExcerciseSetGroups(rawExcerciseSetGroups) {
  const formattedData = {
    create: rawExcerciseSetGroups.map((rawExcerciseSetGroup) => ({
      ...rawExcerciseSetGroup,
      excercise_sets: { create: rawExcerciseSetGroup.excercise_sets },
    })),
  };
  return formattedData;
}

console.log(
  util.inspect(
    formatExcerciseSetGroups(raw_excercise_set_groups),
    false,
    null,
    true
  )
);

// async function updateWorkout() {
//   var workoutData = await prisma.workout.update({
//     where: { workout_id: 1 },
//     data: {
//       user_id: 1,
//       order_index: 0,
//       life_span: 30,
//       workout_name: "tesst",
//       excercise_set_groups: {
//         deleteMany: {},
//         create: excercise_set_groups,
//       },
//     },
//     include: {
//       excercise_set_groups: {
//         include: { excercise_sets: true },
//       },
//     },
//   });
//   console.log(workoutData);
//   console.log(workoutData.excercise_set_groups[0].excercise_sets);
// }

// async function createWorkout() {
//   var workoutData = await prisma.workout.create({
//     data: {
//       user_id: 1,
//       order_index: 0,
//       life_span: 30,
//       workout_name: "tessts",
//       excercise_set_groups: {
//         create: excercise_set_groups,
//       },
//     },
//     include: {
//       excercise_set_groups: {
//         include: { excercise_sets: true },
//       },
//     },
//   });
//   console.log(workoutData);
//   console.log(workoutData.excercise_set_groups[0].excercise_sets);
// }

// updateWorkout();

// createWorkout();
