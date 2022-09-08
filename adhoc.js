const { PrismaClient } = require("@prisma/client");
// NOTE: haven't account for different format AKA the CARDIOexcercises, olmpic excercises etc.
const prisma = new PrismaClient();
const util = require("util");
const _ = require("lodash");

// async function cleanDumbBellExercises() {
//   const exercises = await prisma.excercise.findMany({
//     where: {
//       equipment_required: {
//         has: "MACHINE",
//       },
//     },
//   });
//   for (var ex of exercises) {
//     const new_equipments = ex.equipment_required.filter((e) => e != "MACHINE");
//     await prisma.excercise.update({
//       where: {
//         excercise_name: ex.excercise_name,
//       },
//       data: {
//         equipment_required: new_equipments,
//       },
//     });
//   }
// }

// async function cleanMachineEnum() {
//   const users = await prisma.user.findMany({
//     where: {
//       equipment_accessible: {
//         has: "MACHINE",
//       },
//     },
//   });
//   for (var user of users) {
//     const new_equipments = user.equipment_accessible?.filter(
//       (e) => e != "MACHINE"
//     );
//     const updatedUser = await prisma.user.update({
//       where: {
//         user_id: user.user_id,
//       },
//       data: {
//         equipment_accessible: new_equipments,
//       },
//     });
//   }
// }

async function exportUserWorkout(email, outFilePath) {
  const user = await prisma.user.findUnique({
    where: {
      email: email,
    },
    include: {
      workouts: true,
    },
  });
  var jsonifiedWorkouts = JSON.stringify(user.workouts);
  require("fs").writeFileSync(outFilePath, jsonifiedWorkouts, "utf8");
  // for (var user of users) {
  //   const new_equipments = user.equipment_accessible?.filter(
  //     (e) => e != "MACHINE"
  //   );
  //   const updatedUser = await prisma.user.update({
  //     where: {
  //       user_id: user.user_id,
  //     },
  //     data: {
  //       equipment_accessible: new_equipments,
  //     },
  //   });
  // }
}

async function importUserWorkout(email, inputFilePath) {
  const deletedWorkouts = await prisma.workout.deleteMany({
    where: {
      user: {
        email: email,
      },
    },
  });
  console.log(deletedWorkouts);
}

// excercise_name             String               @id
// excercise_preparation      String?
// excercise_instructions     String?
// excercise_tips             String?
// excercise_utility          ExcerciseUtility[]
// excercise_mechanics        ExcerciseMechanics[]
// excercise_force            ExcerciseForce[]
// target_regions             MuscleRegion[]       @relation(name: "target")
// stabilizer_muscles         MuscleRegion[]       @relation(name: "stabilizer")
// synergist_muscles          MuscleRegion[]       @relation(name: "synergist")
// dynamic_stabilizer_muscles MuscleRegion[]       @relation(name: "dynamic")
// equipment_required         Equipment[]
// body_weight                Boolean
// assisted                   Boolean
// excercise_set_groups       ExcerciseSetGroup[]
// excerciseMetadata          ExcerciseMetadata[]

async function importExercises(inputFilePath) {
  data = require(inputFilePath);
  for (var excercise of data) {
    var {
      target_regions,
      stabilizer_muscles,
      synergist_muscles,
      dynamic_stabilizer_muscles,
      ...data
    } = excercise;
    target_regions = target_regions.map((region) => ({
      muscle_region_id: region.muscle_region_id,
    }));
    stabilizer_muscles = stabilizer_muscles.map((region) => ({
      muscle_region_id: region.muscle_region_id,
    }));
    synergist_muscles = synergist_muscles.map((region) => ({
      muscle_region_id: region.muscle_region_id,
    }));
    dynamic_stabilizer_muscles = dynamic_stabilizer_muscles.map((region) => ({
      muscle_region_id: region.muscle_region_id,
    }));
    try {
      excercise = await prisma.excercise.create({
        data: {
          ...data,
          target_regions: { connect: target_regions },
          stabilizer_muscles: { connect: stabilizer_muscles },
          dynamic_stabilizer_muscles: { connect: dynamic_stabilizer_muscles },
          synergist_muscles: { connect: synergist_muscles },
        },
      });
      console.log(excercise);
    } catch (e) {
      console.log(e);
    }
  }
}

importExercises("./weighted_excercises.json");
