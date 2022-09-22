"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.workoutGenerator = void 0;
const workout_manager_1 = require("./workout_manager");
const graphql_1 = require("../../types/graphql");
const _ = require("lodash");
const rotations_type = [
    [
        graphql_1.MuscleRegionType.Thighs,
        graphql_1.MuscleRegionType.Chest,
        graphql_1.MuscleRegionType.Back,
        graphql_1.MuscleRegionType.Shoulder,
        graphql_1.MuscleRegionType.UpperArm,
    ],
    [
        graphql_1.MuscleRegionType.Back,
        graphql_1.MuscleRegionType.Chest,
        graphql_1.MuscleRegionType.Shoulder,
        graphql_1.MuscleRegionType.Thighs,
        graphql_1.MuscleRegionType.UpperArm,
    ],
    [
        graphql_1.MuscleRegionType.Chest,
        graphql_1.MuscleRegionType.Back,
        graphql_1.MuscleRegionType.Shoulder,
        graphql_1.MuscleRegionType.Thighs,
        graphql_1.MuscleRegionType.UpperArm,
    ],
];
const workoutGenerator = (numberOfWorkouts, context) => __awaiter(void 0, void 0, void 0, function* () {
    const prisma = context.dataSources.prisma;
    const user = context.user;
    const workout_name_list = [
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
    const generated_workout_list = [];
    // Contains a list of equipment that the user has NO access to.
    const user_constaints = _.differenceWith(Object.keys(graphql_1.Equipment), user.equipment_accessible, _.isEqual);
    // Randomly select a rotation plan for the requestor
    const randomRotation = rotations_type[Math.floor(Math.random() * rotations_type.length)];
    // excercise_pointer used with randomRotation determines which exercise type should be next
    var excercise_pointer = 0;
    // Core logic
    for (let day = 0; day < numberOfWorkouts; day++) {
        // Outer-loop is to create the workouts
        let list_of_excercise_set_groups = [];
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
                const waist_excercise = yield prisma.excercise.findMany({
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
                const excercise_1 = waist_excercise.splice(Math.floor(Math.random() * waist_excercise.length), 1)[0];
                const excercise_2 = waist_excercise.splice(Math.floor(Math.random() * waist_excercise.length), 1)[0];
                list_of_excercise_set_groups.push(yield formatAndGenerateExcerciseSets(excercise_1, context));
                list_of_excercise_set_groups.push(yield formatAndGenerateExcerciseSets(excercise_2, context));
            }
            else {
                // insert excercises from rotation_type in a order for iteration 1,2,3
                const excercises_in_category = yield prisma.excercise.findMany({
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
                        body_weight: !(user.equipment_accessible.length > 0),
                        assisted: false,
                    },
                });
                if (excercises_in_category.length > 0) {
                    var randomSelectedExcercise = excercises_in_category[Math.floor(Math.random() * excercises_in_category.length)];
                    list_of_excercise_set_groups.push(yield formatAndGenerateExcerciseSets(randomSelectedExcercise, context));
                }
                excercise_pointer++;
            }
        }
        // create workout and generate the associated excercisemetadata
        const createdWorkout = yield prisma.workout.create({
            data: {
                workout_name: workout_name_list.splice((Math.random() * workout_name_list.length) | 0, 1)[0],
                order_index: yield (0, workout_manager_1.getActiveWorkoutCount)(context),
                user_id: user.user_id,
                life_span: 12,
                excercise_set_groups: { create: list_of_excercise_set_groups },
            },
            include: {
                excercise_set_groups: { include: { excercise_sets: true } },
            },
        });
        // push the result ot the list
        generated_workout_list.push(createdWorkout);
    }
    return generated_workout_list;
});
exports.workoutGenerator = workoutGenerator;
function formatAndGenerateExcerciseSets(excercise, context) {
    return __awaiter(this, void 0, void 0, function* () {
        const prisma = context.dataSources.prisma;
        const user = context.user;
        var previous_excercise_sets = [];
        var excercise_sets_input = [];
        // Checks if there is previous data, will use that instead
        var previousExcerciseSetGroup = yield prisma.excerciseSetGroup.findFirst({
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
        (0, workout_manager_1.generateExerciseMetadata)(context, excercise.excercise_name);
        if (previousExcerciseSetGroup != null) {
            // previous_excercise_sets = previousExcerciseSetGroup.excercise_sets;
            previous_excercise_sets.forEach((prev_set) => {
                var excercise_set_input = _.omit(prev_set, "excercise_set_group_id", "excercise_set_id");
                excercise_set_input["actual_reps"] = null;
                excercise_set_input["actual_weight"] = null;
                excercise_sets_input.push(excercise_set_input);
            });
        }
        else {
            // No previous data
            excercise_sets_input = new Array(5).fill({
                target_weight: 0,
                weight_unit: "KG",
                target_reps: 0,
                actual_weight: null,
                actual_reps: null,
            });
        }
        return {
            excercise: { connect: { excercise_name: excercise.excercise_name } },
            excercise_set_group_state: graphql_1.ExcerciseSetGroupState.NormalOperation,
            excercise_sets: { create: excercise_sets_input },
        };
    });
}
//# sourceMappingURL=workout_generator.js.map