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

async function cleanMachineEnum() {
  const users = await prisma.user.findMany({
    where: {
      equipment_accessible: {
        has: "MACHINE",
      },
    },
  });
  for (var user of users) {
    const new_equipments = user.equipment_accessible?.filter(
      (e) => e != "MACHINE"
    );
    const updatedUser = await prisma.user.update({
      where: {
        user_id: user.user_id,
      },
      data: {
        equipment_accessible: new_equipments,
      },
    });
  }
}

cleanMachineEnum();
