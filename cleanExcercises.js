const csv = require("csvtojson");
const { json } = require("stream/consumers");

const muscle_data_path = "./muscle_data_set/muscle_data_set.csv";

muscleData = [
 {
   "muscle_region_name": "Adductors",
   "muscle_region_type": "HIPS"
 },
 {
   "muscle_region_name": "Biceps Brachii",
   "muscle_region_type": "UPPER_ARM"
 },
 {
   "muscle_region_name": "Brachialis",
   "muscle_region_type": "UPPER_ARM"
 },
 {
   "muscle_region_name": "Brachioradialis",
   "muscle_region_type": "FORE_ARM"
 },
 {
   "muscle_region_name": "Deltoid, Anterior",
   "muscle_region_type": "SHOULDER"
 },
 {
   "muscle_region_name": "Deltoid, Lateral",
   "muscle_region_type": "SHOULDER"
 },
 {
   "muscle_region_name": "Deltoid, Posterior",
   "muscle_region_type": "SHOULDER"
 },
 {
   "muscle_region_name": "Deep Hip External Rotators",
   "muscle_region_type": "HIPS"
 },
 {
   "muscle_region_name": "Erector Spinae",
   "muscle_region_type": "WAIST"
 },
 {
   "muscle_region_name": "Gastrocnemius",
   "muscle_region_type": "CALVES"
 },
 {
   "muscle_region_name": "Gluteus Maximus",
   "muscle_region_type": "THIGHS"
 },
 {
   "muscle_region_name": "Gluteus Medius",
   "muscle_region_type": "THIGHS"
 },
 {
   "muscle_region_name": "Gluteus Minimus",
   "muscle_region_type": "THIGHS"
 },
 {
   "muscle_region_name": "Gracilis",
   "muscle_region_type": "THIGHS"
 },
 {
   "muscle_region_name": "Hamstrings",
   "muscle_region_type": "THIGHS"
 },
 {
   "muscle_region_name": "Iliopsoas",
   "muscle_region_type": "HIPS"
 },
 {
   "muscle_region_name": "Infraspinatus",
   "muscle_region_type": "BACK"
 },
 {
   "muscle_region_name": "Latissimus Dorsi",
   "muscle_region_type": "BACK"
 },
 {
   "muscle_region_name": "Levator Scapulae",
   "muscle_region_type": "BACK"
 },
 {
   "muscle_region_name": "Obliques",
   "muscle_region_type": "WAIST"
 },
 {
   "muscle_region_name": "Pectineous",
   "muscle_region_type": "HIPS"
 },
 {
   "muscle_region_name": "Pectoralis Major, Clavicular Head",
   "muscle_region_type": "CHEST"
 },
 {
   "muscle_region_name": "Pectoralis Major, Sternal Head",
   "muscle_region_type": "CHEST"
 },
 {
   "muscle_region_name": "Teres Major",
   "muscle_region_type": "BACK"
 },
 {
   "muscle_region_name": "Teres Minor",
   "muscle_region_type": "BACK"
 },
 {
   "muscle_region_name": "Tibialis Anterior",
   "muscle_region_type": "CALVES"
 },
 {
   "muscle_region_name": "Transverse Abdominus",
   "muscle_region_type": "WAIST"
 },
 {
   "muscle_region_name": "Trapezius, Lower Fibers",
   "muscle_region_type": "BACK"
 },
 {
   "muscle_region_name": "Trapezius,  Middle Fibers",
   "muscle_region_type": "BACK"
 },
 {
   "muscle_region_name": "Trapezius,  Upper Fibers",
   "muscle_region_type": "BACK"
 },
 {
   "muscle_region_name": "Triceps Brachii",
   "muscle_region_type": "UPPER_ARM"
 },
 {
   "muscle_region_name": "Wrist Extensors",
   "muscle_region_type": "FORE_ARM"
 },
 {
   "muscle_region_name": "Wrist Flexors",
   "muscle_region_type": "FORE_ARM"
 },
 {
   "muscle_region_name": "Pectoralis Minor",
   "muscle_region_type": "CHEST"
 },
 {
   "muscle_region_name": "Popliteus",
   "muscle_region_type": "CALVES"
 },
 {
   "muscle_region_name": "Quadratus Lumborum",
   "muscle_region_type": "WAIST"
 },
 {
   "muscle_region_name": "Quadriceps",
   "muscle_region_type": "THIGHS"
 },
 {
   "muscle_region_name": "Rectus Abdominis",
   "muscle_region_type": "WAIST"
 },
 {
   "muscle_region_name": "Rhomboids",
   "muscle_region_type": "BACK"
 },
 {
   "muscle_region_name": "Sartorius",
   "muscle_region_type": "THIGHS"
 },
 {
   "muscle_region_name": "Serratus Anterior",
   "muscle_region_type": "WAIST"
 },
 {
   "muscle_region_name": "Soleus",
   "muscle_region_type": "CALVES"
 },
 {
   "muscle_region_name": "Splenius",
   "muscle_region_type": "NECK"
 },
 {
   "muscle_region_name": "Sternocleidomastoid",
   "muscle_region_type": "NECK"
 },
 {
   "muscle_region_name": "Subscapularis",
   "muscle_region_type": "BACK"
 },
 {
   "muscle_region_name": "Supraspinatus",
   "muscle_region_type": "SHOULDERS"
 },
 {
   "muscle_region_name": "Tensor Fasciae Latae",
   "muscle_region_type": "HIPS"
 }
]

const equipment = [
  "DUMBBELL",
  "BARBELL",
  "KETTLEBELL",
  "CABLE",
  "LEVER",
  "SUSPENSION",
  "T_BAR",
  "MACHINE",
  "TRAP_BAR",
  "SLED",
  "SMITH"
]

async function loadData() {
      const musceData = muscleData.map(muscle => muscle.muscle_region_name);
      var files = require("fs").readdirSync("./excercise_data_set/");
      for  (file of files) {
        var filepath = "./excercise_data_set/" + file;
        var outFilePath = "./cleaned_data_set/" + file + ".json";
        if (filepath == "./excercise_data_set/.DS_Store") {continue}
         await csv()
          .fromFile(filepath)
          .then((excerciseJson) => {
            var excercises = parseJson(excerciseJson,musceData)
            var json = JSON.stringify(excercises);
            require("fs").writeFileSync(outFilePath, json, 'utf8');
          })
        }

}



function parseJson(excerciseJson, muscleList) {
  parsedJson = []
  for (var jsonObj of excerciseJson) {
    const args = {
      excercise_name: jsonObj.excercise_name,
      excercise_preparation: jsonObj.preparation,
      excercise_instructions: jsonObj.execution,
      excercise_tips: jsonObj.comments,
      excercise_utility: JSON.parse(
        jsonObj.utility.replace(/'/g, '"')
      ).map((e) => e.toUpperCase()),
      excercise_mechanics: JSON.parse(
        jsonObj.mechanics.replace(/'/g, '"')
      ).map((e) => e.toUpperCase()),
      excercise_force: JSON.parse(
        jsonObj.force.replace(/'/g, '"')
      ).map((e) => e.toUpperCase()),
      target_regions: JSON.parse(
        jsonObj.target_muscles.replace(/'/g, '"')
      ).map((muscleRegion) => muscleList.find((muscleNameInList)=> muscleNameInList.replace('/[.,\s]/g', '').includes(muscleRegion.replace('/[.,\s]/g', '')) || muscleRegion.replace('/[.,\s]/g', '').includes(muscleNameInList.replace('/[.,\s]/g', '')))),
      synergist_muscles: JSON.parse(
        jsonObj.synergist_muscles.replace(/'/g, '"')
      ).map((muscleRegion) => muscleList.find((muscleNameInList)=> muscleNameInList.replace('/[.,\s]/g', '').includes(muscleRegion.replace('/[.,\s]/g', '')) || muscleRegion.replace('/[.,\s]/g', '').includes(muscleNameInList.replace('/[.,\s]/g', '')))),
      dynamic_stabilizer_muscles: JSON.parse(
        jsonObj.dynamic_stabilizer_muscles.replace(/'/g, '"')
      ).map((muscleRegion) => muscleList.find((muscleNameInList)=> muscleNameInList.replace('/[.,\s]/g', '').includes(muscleRegion.replace('/[.,\s]/g', '')) || muscleRegion.replace('/[.,\s]/g', '').includes(muscleNameInList.replace('/[.,\s]/g', '')))),
      stabilizer_muscles: JSON.parse(
        jsonObj.stabalizer_muscles.replace(/'/g, '"')
      ).map((muscleRegion) => muscleList.find((muscleNameInList)=> muscleNameInList.replace('/[.,\s]/g', '').includes(muscleRegion.replace('/[.,\s]/g', '')) || muscleRegion.replace('/[.,\s]/g', '').includes(muscleNameInList.replace('/[.,\s]/g', '')))),
    };
    const regex = /[.,\s]/g;
    const normalizedArgs = Object.values(args).map(arg=>JSON.stringify(arg).replace(regex,'').replace(/-/g, '_').toLowerCase()).reduce((a,b) => a + b)
    const updatedArgs = {
    ...args,
    equipment_required: equipment.map((equipment_name) =>  {
        normalized_name = equipment_name.replace(regex,'').replace(/-/g, '_').toLowerCase()
        if(normalizedArgs.includes(normalized_name)){
          return equipment_name
        } else{
          return
        }
      }
    ).filter(obj=> obj != undefined)
  }
    parsedJson.push(updatedArgs);
  }
  return parsedJson;
}

// async function deleteExcercise(excercise_name) {
//   deletedExcercise = await prisma.excercise.delete({
//     where: {
//       excercise_name: excercise_name,
//     },
//   });

// async function getExcercises() {
//   excercises = await prisma.excercise.findMany();
// }

loadData();
