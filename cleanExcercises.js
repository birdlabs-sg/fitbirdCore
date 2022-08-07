const { Equipment } = require("@prisma/client");
const csv = require("csvtojson");
const { flatten } = require("lodash");
const { json } = require("stream/consumers");
const { PrismaClient } = require("@prisma/client");
// NOTE: haven't account for different format AKA the CARDIOexcercises, olmpic excercises etc.
const prisma = new PrismaClient();

const muscle_data_path = "./muscle_data_set/muscle_data_set.json";

const muscleData = require(muscle_data_path);
var stringSimilarity = require("string-similarity");

const equipment = Object.keys(Equipment);

console.log(equipment);

async function loadData() {
  const musceData = muscleData.map((muscle) => muscle.muscle_region_name);
  var files = require("fs").readdirSync("./excercise_data_set/");
  for (file of files) {
    if (file == ".DS_Store") continue;
    var filepath = "./excercise_data_set/" + file;
    var outFilePath = "./cleaned_data_set/" + file + ".json";

    await csv()
      .fromFile(filepath)
      .then((excerciseJson) => {
        var excercises = parseJson(excerciseJson, musceData);
        var json = JSON.stringify(excercises);
        require("fs").writeFileSync(outFilePath, json, "utf8");
      });
  }
}

function parseJson(excerciseJson, muscleList) {
  parsedJson = [];
  for (var jsonObj of excerciseJson) {
    const args = {
      excercise_name: jsonObj.excercise_name,
      excercise_preparation: jsonObj.preparation,
      excercise_instructions: jsonObj.execution,
      excercise_tips: jsonObj.comments,
      excercise_utility: JSON.parse(jsonObj.utility.replace(/'/g, '"')).map(
        (e) => e.toUpperCase()
      ),
      excercise_mechanics: JSON.parse(jsonObj.mechanics.replace(/'/g, '"')).map(
        (e) => e.toUpperCase()
      ),
      excercise_force: JSON.parse(jsonObj.force.replace(/'/g, '"')).map((e) =>
        e.toUpperCase()
      ),
      target_regions: JSON.parse(jsonObj.target_muscles.replace(/'/g, '"')).map(
        (muscleRegion) => {
          return excerciseMatcher(muscleRegion, muscleList);
        }
      ),
      synergist_muscles: JSON.parse(
        jsonObj.synergist_muscles.replace(/'/g, '"')
      ).map((muscleRegion) => {
        return excerciseMatcher(muscleRegion, muscleList);
      }),
      dynamic_stabilizer_muscles: JSON.parse(
        jsonObj.dynamic_stabilizer_muscles.replace(/'/g, '"')
      ).map((muscleRegion) => {
        return excerciseMatcher(muscleRegion, muscleList);
      }),
      stabilizer_muscles: JSON.parse(
        jsonObj.stabalizer_muscles.replace(/'/g, '"')
      ).map((muscleRegion) => {
        return excerciseMatcher(muscleRegion, muscleList);
      }),
    };
    const regex = /[.,\s]/g;
    const normalizedArgs = Object.values(args)
      .map((arg) =>
        JSON.stringify(arg).replace(regex, "").replace(/-/g, "_").toLowerCase()
      )
      .reduce((a, b) => a + b);
    if (
      normalizedArgs.includes("padding") ||
      normalizedArgs.includes("apparatus")
    ) {
      // skipped
      continue;
    }
    const updatedArgs = {
      ...args,
      equipment_required: equipment
        .map((equipment_name) => {
          normalized_name = equipment_name
            .replace(regex, "")
            .replace(/-/g, "_")
            .toLowerCase();
          if (
            equipment_name == "TRAP_BAR" &&
            normalizedArgs.includes("trapbar")
          ) {
            return equipment_name;
          }
          if (
            equipment_name == "PARALLEL_BARS" &&
            normalizedArgs.includes("parallelbars")
          ) {
            console.log("foundparra");
            return equipment_name;
          }
          if (
            equipment_name == "STABILITY_BALL" &&
            normalizedArgs.includes("stabilityball")
          ) {
            return equipment_name;
          }
          if (
            equipment_name == "PULL_UP_BAR" &&
            (normalizedArgs.includes("pullup") ||
              normalizedArgs.includes("highbar") ||
              normalizedArgs.includes("chinup"))
          ) {
            return equipment_name;
          }
          if (normalizedArgs.includes(normalized_name)) {
            return equipment_name;
          } else {
            return;
          }
        })
        .filter((obj) => obj != undefined),
      assisted: normalizedArgs.includes("assisted"),
      body_weight:
        normalizedArgs.includes("pullup") ||
        normalizedArgs.includes("chinup") ||
        normalizedArgs.includes("pushup") ||
        normalizedArgs.includes("suspension") ||
        normalizedArgs.includes("assisted") ||
        normalizedArgs.includes("assisted") ||
        (!normalizedArgs.includes("weighted") &&
          !normalizedArgs.includes("barbell") &&
          !normalizedArgs.includes("kettlebell") &&
          !normalizedArgs.includes("cable") &&
          !normalizedArgs.includes("lever") &&
          !normalizedArgs.includes("tbar") &&
          !normalizedArgs.includes("trapbar") &&
          !normalizedArgs.includes("sled") &&
          !normalizedArgs.includes("smith") &&
          !normalizedArgs.includes("preacher")),
    };
    parsedJson.push(updatedArgs);
  }
  return parsedJson;
}

function excerciseMatcher(muscleRegion, muscleList) {
  if (muscleRegion.includes("Abductors")) {
    return "Abductors";
  } else if (muscleRegion.includes("Pronator")) {
    console.log("contains pronator");
    return "Pronators";
  } else if (muscleRegion.includes("Back")) {
    return "Latissimus Dorsi";
  } else if (muscleRegion.includes("Tricep")) {
    return "Triceps Brachii";
  } else {
    var firstTry = muscleList.find(
      (muscleNameInList) =>
        stringSimilarity.compareTwoStrings(
          muscleNameInList.replace("/[.,s]/g", ""),
          muscleRegion.replace("/[.,s]/g", "")
        ) > 0.8
    );
    if (firstTry != undefined) {
      return firstTry;
    }
    var secondTry = muscleList.find(
      (muscleNameInList) =>
        stringSimilarity.compareTwoStrings(
          muscleNameInList.replace("/[.,s]/g", ""),
          muscleRegion.replace("/[.,s]/g", "")
        ) > 0.6
    );
    if (secondTry != undefined) {
      return secondTry;
    }
    var thirdTry = muscleList.find(
      (muscleNameInList) =>
        stringSimilarity.compareTwoStrings(
          muscleNameInList.replace("/[.,s]/g", ""),
          muscleRegion.replace("/[.,s]/g", "")
        ) > 0.4
    );
    if (thirdTry != undefined) {
      return thirdTry;
    }

    var lastTry = muscleList.find(
      (muscleNameInList) =>
        stringSimilarity.compareTwoStrings(
          muscleNameInList.replace("/[.,s]/g", ""),
          muscleRegion.replace("/[.,s]/g", "")
        ) > 0.3
    );
    if (lastTry != undefined) {
      return lastTry;
    } else {
      console.log("CANT FIND:", muscleRegion);
      return null;
    }
  }
}

async function combineData() {
  var files = require("fs").readdirSync("./cleaned_data_set/");
  var combinedFiles = [];
  for (file of files) {
    if (file == ".DS_Store") continue;
    if (file == "combined_excercises.json") continue;
    var filepath = "./cleaned_data_set/" + file;
    combinedFiles.push(require(filepath));
  }
  var flattenedFile = combinedFiles.flat(1);
  onlyUniqueExcercises = [
    ...new Map(
      flattenedFile.map((excercise) => [excercise["excercise_name"], excercise])
    ).values(),
  ];
  var json = JSON.stringify(onlyUniqueExcercises);
  require("fs").writeFileSync(
    "./cleaned_data_set/combined_excercises.json",
    json,
    "utf8"
  );
}

// async function deleteExcercises() {
//   deletedExcercise = await prisma.excercise.deleteMany({});
// }
// async function getExcercises() {
//   excercises = await prisma.excercise.findMany();
// }

loadData().then(() => combineData());

// deleteExcercises();
