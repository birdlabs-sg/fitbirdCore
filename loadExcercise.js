const { PrismaClient } = require('@prisma/client')
// NOTE: haven't account for different format AKA the CARDIOexcercises, olmpic excercises etc.
const prisma = new PrismaClient()
const csv=require('csvtojson') 

async function loadExcercise() {
    var files = require('fs').readdirSync('./cleaned_data_set/');
    var combinedExcerciseJsonList = []
    for (file of files) {
        if (file != ".DS_Store") {
            file_path = './cleaned_data_set/' + file
            excerciseJson = require('fs').readFileSync(file_path, "utf8")
            parsedExcerciseList = eval(JSON.parse(excerciseJson))
            combinedExcerciseJsonList = parsedExcerciseList.concat(combinedExcerciseJsonList)
        }
    }
    const uniqueExcerciseList = combinedExcerciseJsonList.filter((e, i) => combinedExcerciseJsonList.findIndex(a => a["excercise_name"] === e["excercise_name"]) === i);

    for (excercise of uniqueExcerciseList) {
        // iterate through each excercises
        targetRegionArray = []
        for (muscle_name of excercise.target_regions) {
            if (muscle_name == null) continue
            muscle_region = await prisma.muscleRegion.findFirst({where: {
                muscle_region_name: muscle_name,
            }})
            targetRegionArray.push({muscle_region_id: muscle_region.muscle_region_id})
        }

        synergistMusclesArray = []
        for (muscle_name of excercise.synergist_muscles) {
             if (muscle_name == null) continue
            muscle_region = await prisma.muscleRegion.findFirst({where: {
                muscle_region_name: muscle_name,
            }})
            synergistMusclesArray.push({muscle_region_id: muscle_region.muscle_region_id})
        }

        dynamicStabilizerMusclesArray = []
        for (muscle_name of excercise.dynamic_stabilizer_muscles) {
             if (muscle_name == null) continue
            muscle_region = await prisma.muscleRegion.findFirst({where: {
                muscle_region_name: muscle_name,
            }})
            dynamicStabilizerMusclesArray.push({muscle_region_id: muscle_region.muscle_region_id})
        }

        stabilizerMusclesArray = []
        for (muscle_name of excercise.stabilizer_muscles) {
             if (muscle_name == null) continue
            muscle_region = await prisma.muscleRegion.findFirst({where: {
                muscle_region_name: muscle_name,
            }})
            stabilizerMusclesArray.push({muscle_region_id: muscle_region.muscle_region_id})
        }

        newArgs = {
            ...excercise,
            target_regions: {
                connect: targetRegionArray ?? []
            },
            stabilizer_muscles: {
                connect: stabilizerMusclesArray ?? []
            },
            synergist_muscles: {
                connect: synergistMusclesArray ?? []
            },
            dynamic_stabilizer_muscles: {
                connect: dynamicStabilizerMusclesArray ?? []
            },
        }
        const newExcercises = await prisma.excercise.create({
            data: newArgs
        })
        console.log(newExcercises)
    }
}

async function loadMuscleGroups(){
    muscleData = require("./muscle_data_set/muscle_data_set.json")
    for (muscle of muscleData) {
        existingMuscleGroup =  await prisma.muscleRegion.findUnique({
            where: {
                muscle_region_name: muscle.muscle_region_name
            }
        })
        if (existingMuscleGroup == null) {
        await prisma.muscleRegion.create({
            data: muscle
        })
        }
    }
    console.log("Generated all muscle groups")
}

async function deleteExcercise(excercise_name) {
    deletedExcercise = await prisma.excercise.delete(
       { where: {
        excercise_name : excercise_name
    }}
    )
}


async function getExcercises() {
    excercises = await prisma.excercise.findMany()
}

loadMuscleGroups().then(() => loadExcercise());
// loadExcercise()

