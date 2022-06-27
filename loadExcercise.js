const { PrismaClient } = require('@prisma/client')
// NOTE: haven't account for different format AKA the CARDIOexcercises, olmpic excercises etc.
const prisma = new PrismaClient()
const csv=require('csvtojson') 

async function loadExcercise(filepath) {
    let allArgs = []
    var files = require('fs').readdirSync('./excercise_data_set/');
    for (i = 0 ; i < files.length ; i++) {
        if (files[i] != ".DS_Store" 
        && files[i] != "CardioExercises.csv" 
        && files[i] != "KettlebellExercises.csv" 
        && files[i] != "PowerExercises.csv"
        && files[i] != "OtherExercises.csv"
        && files[i] != "OlympicWeightlifting.csv") {
            filepath = "./excercise_data_set/" + files[i]
                parsedExcercises = await csv()
                .fromFile(filepath)
                .then((jsonObjList) => {
                    const parsedFile = []
                    for (jsonObj of jsonObjList) {
                        args = {
                            "excercise_name": jsonObj.excercise_name,
                            "excercise_description": jsonObj.preparation,
                            "excercise_instructions": jsonObj.execution,
                            "excercise_tips": jsonObj.comments,
                            "excercise_utility": JSON.parse(jsonObj.utility.replace(/'/g, "\"")).map(e => e.toUpperCase()),
                            "excercise_mechanics": JSON.parse(jsonObj.mechanics.replace(/'/g, "\"")).map(e => e.toUpperCase()),
                            "excercise_force": JSON.parse(jsonObj.force.replace(/'/g, "\"")).map(e => e.toUpperCase()),
                            "target_regions": JSON.parse(jsonObj.target_muscles.replace(/'/g, "\"")),
                            "synergist_muscles":JSON.parse(jsonObj.synergist_muscles.replace(/'/g, "\"")),
                            "dynamic_stabilizer_muscles": JSON.parse(jsonObj.dynamic_stabilizer_muscles.replace(/'/g, "\"")),
                            "stabilizer_muscles": JSON.parse(jsonObj.stabalizer_muscles.replace(/'/g, "\"")),
                        }
                        parsedFile.push(args)
                    }
                    return parsedFile
                })
                allArgs = allArgs.concat(parsedExcercises)
        }
    }

    const uniqueArgs = allArgs.filter((e, i) => allArgs.findIndex(a => a["excercise_name"] === e["excercise_name"]) === i);

    for (excercise of uniqueArgs) {
        // iterate through each excercises
        targetRegionArray = []
        for (muscle_name of excercise.target_regions) {
            muscle_region = await prisma.muscleRegion.findFirst({where: {
                muscle_region_name: muscle_name,
            }})
            targetRegionArray.push({muscle_region_id: muscle_region.muscle_region_id})
        }

        synergistMusclesArray = []
        for (muscle_name of excercise.synergist_muscles) {
            muscle_region = await prisma.muscleRegion.findFirst({where: {
                muscle_region_name: muscle_name,
            }})
            synergistMusclesArray.push({muscle_region_id: muscle_region.muscle_region_id})
        }

        dynamicStabilizerMusclesArray = []
        for (muscle_name of excercise.dynamic_stabilizer_muscles) {
            muscle_region = await prisma.muscleRegion.findFirst({where: {
                muscle_region_name: muscle_name,
            }})
            dynamicStabilizerMusclesArray.push({muscle_region_id: muscle_region.muscle_region_id})
        }

        stabilizerMusclesArray = []
        for (muscle_name of excercise.stabilizer_muscles) {
            muscle_region = await prisma.muscleRegion.findFirst({where: {
                muscle_region_name: muscle_name,
            }})
            stabilizerMusclesArray.push({muscle_region_id: muscle_region.muscle_region_id})
        }

        newArgs = {
            ...excercise,
            target_regions: {
                connect: targetRegionArray
            },
            stabilizer_muscles: {
                connect: stabilizerMusclesArray
            },
            synergist_muscles: {
                connect: synergistMusclesArray
            },
            dynamic_stabilizer_muscles: {
                connect: dynamicStabilizerMusclesArray
            },
        }
        const newExcercises = await prisma.excercise.create({
            data: newArgs
        })
        console.log(newExcercises)
    }
}

async function deleteExcercise(excercise_id) {
    deletedExcercise = await prisma.excercise.delete(
       { where: {
        excercise_id : excercise_id
    }}
    )
    console.log(deletedExcercise)
}


async function getExcercises() {
    excercises = await prisma.excercise.findMany()
    console.log(excercises)
}

loadExcercise()


// deleteExcercise([1,2,3,4,5,6,7,8]);
// getExcercises();

// console.log(arr)


