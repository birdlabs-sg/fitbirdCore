const { PrismaClient } = require("@prisma/client");
// NOTE: haven't account for different format AKA the CARDIOexcercises, olmpic excercises etc.
const prisma = new PrismaClient();
const util = require("util");
const _ = require("lodash");

async function cleanDumbBellExercises() {
  const exercises = await prisma.excercise.findMany({
    where: {
      excercise_name: {
        contains: "Plank",
      },
    },
  });
  for (var ex of exercises) {
    await prisma.excercise.deleteMany({
      where: {
        excercise_name: {
          contains: "Plank",
        },
      },
    });
  }
  console.log(exercises);
}

cleanDumbBellExercises();
