"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
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
exports.generateNextWorkout = exports.workoutGeneratorV2 = exports.workoutGenerator = void 0;
const graphql_1 = require("../../../types/graphql");
const constants_1 = require("./constants");
const utils_1 = require("../utils");
const progressive_overloader_1 = require("../progressive_overloader/progressive_overloader");
const client_1 = require("@prisma/client");
const _ = require("lodash");
const workoutSplit = __importStar(require("./rotations_types_general"));
/**
 * Generates a list of workouts (AKA a single rotation) based on requestors's equipment constraints.
 */
const workoutGenerator = (numberOfWorkouts, context) => __awaiter(void 0, void 0, void 0, function* () {
    const prisma = context.dataSources.prisma;
    const user = context.user;
    // guard clause
    if (numberOfWorkouts > 6) {
        throw Error("Can only generate 6 workouts maximum.");
    }
    const generated_workout_list = [];
    // Contains a list of equipment that the user has NO access to.
    const user_constaints = _.differenceWith(Object.keys(client_1.Equipment), user.equipment_accessible, _.isEqual);
    // Randomly select a rotation plan for the requestor
    const random_rotation = _.sample(constants_1.rotations_type);
    // excercise_pointer used with randomRotation determines which exercise type should be next
    var excercise_pointer = 0;
    // Core logic
    for (let day = 0; day < numberOfWorkouts; day++) {
        // Outer-loop is to create the workouts
        const list_of_excercise_set_groups = [];
        for (let excercise_index = 0; excercise_index < 4; excercise_index++) {
            // inner-loop is to create each workout.
            // Each workout will have 5 excercises. First 3 follows the rotation_type in a round robin fashion
            // Last 2 are waist excercises (ABS)
            if (excercise_pointer > random_rotation.length - 1) {
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
                const [excercise_1, excercise_2] = _.sampleSize(waist_excercise, 2);
                list_of_excercise_set_groups.push(yield (0, utils_1.formatAndGenerateExcerciseSets)(excercise_1.excercise_name, context));
                list_of_excercise_set_groups.push(yield (0, utils_1.formatAndGenerateExcerciseSets)(excercise_2.excercise_name, context));
            }
            else {
                // insert excercises from rotation_type in a order for iteration 1,2,3
                const excercises_in_category = yield prisma.excercise.findMany({
                    where: {
                        target_regions: {
                            some: {
                                muscle_region_type: random_rotation[excercise_pointer],
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
                    const random_exercise = _.sample(excercises_in_category);
                    list_of_excercise_set_groups.push(yield (0, utils_1.formatAndGenerateExcerciseSets)(random_exercise.excercise_name, context));
                }
                excercise_pointer++;
            }
        }
        // create workout and generate the associated excercisemetadata
        const createdWorkout = yield prisma.workout.create({
            data: {
                workout_name: _.sample(constants_1.workout_name_list),
                order_index: yield (0, utils_1.getActiveWorkoutCount)(context),
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
const workoutGeneratorV2 = (numberOfWorkouts, context) => __awaiter(void 0, void 0, void 0, function* () {
    const prisma = context.dataSources.prisma;
    const user = context.user;
    // guard clause
    if (numberOfWorkouts > 6) {
        throw Error("Can only generate 6 workouts maximum per week.");
    }
    if (numberOfWorkouts < 2) {
        throw Error("A minimum of 2 workouts per week.");
    }
    const generated_workout_list = [];
    // Contains a list of equipment that the user has NO access to.
    const user_constaints = _.differenceWith(Object.keys(client_1.Equipment), user.equipment_accessible, _.isEqual);
    // The name selector cannot be random
    // excercise_pointer used with randomRotation determines which exercise type should be next
    var excercise_pointer = 0;
    let rotationSequenceMuscle = [[]];
    switch (numberOfWorkouts) {
        case 2:
            rotationSequenceMuscle = workoutSplit.twoDaySplitMuscle;
        case 3:
            rotationSequenceMuscle = workoutSplit.threeDaySplitMuscle;
        case 4:
            rotationSequenceMuscle = workoutSplit.fourDaySplitMuscle;
        case 5:
            rotationSequenceMuscle = workoutSplit.fiveDaySplit;
        case 6:
            rotationSequenceMuscle = workoutSplit.sixDaySplit;
    }
    // Core logic
    yield excerciseSelector(numberOfWorkouts, context, rotationSequenceMuscle, user_constaints, generated_workout_list);
    return generated_workout_list;
});
exports.workoutGeneratorV2 = workoutGeneratorV2;
// re configured the selector to make it more usable among different exercise plans
const excerciseSelector = (numberOfWorkouts, context, rotationSequence /*| ExcerciseForce[][]*/, user_constaints, generated_workout_list) => __awaiter(void 0, void 0, void 0, function* () {
    const prisma = context.dataSources.prisma;
    const user = context.user;
    let Rotation = [];
    let max = 0;
    for (let day = 0; day < numberOfWorkouts; day++) {
        let list_of_excercises = [];
        Rotation = rotationSequence[day];
        if (numberOfWorkouts > 5) {
            max = Rotation.length - 1; // 1 less exercise per day if days is more than 5
        }
        else {
            max = Rotation.length;
        }
        for (let excercise_index = 0; excercise_index < max; excercise_index++) {
            const excercises_in_category = yield prisma.excercise.findMany({
                where: {
                    target_regions: {
                        some: {
                            muscle_region_type: Rotation[excercise_index],
                        },
                    },
                    NOT: {
                        equipment_required: {
                            hasSome: user_constaints,
                        },
                    },
                    body_weight: !(user.equipment_accessible.length > 0),
                    assisted: false,
                },
            });
            if (excercises_in_category.length > 0) {
                var randomSelectedExcercise = _.sample(excercises_in_category);
                list_of_excercises.push(yield (0, utils_1.formatAndGenerateExcerciseSets)(randomSelectedExcercise.excercise_name, context));
            }
        }
        try {
            const createdWorkout = yield prisma.workout.create({
                data: {
                    workout_name: _.sample(constants_1.workout_name_list),
                    order_index: yield (0, utils_1.getActiveWorkoutCount)(context),
                    user_id: user.user_id,
                    life_span: 12,
                    excercise_set_groups: { create: list_of_excercises },
                },
                include: {
                    excercise_set_groups: true,
                },
            });
            generated_workout_list.push(createdWorkout);
        }
        catch (e) {
            console.log(e);
        }
    }
    // create workout and generate the associated excercisemetadata
});
/**
 * Generates the next workout, using the previousWorkout parameter as the base.
 * Note: This function is only called when a workout has been completed.
 */
function generateNextWorkout(context, previousWorkout, next_workout_excercise_set_groups) {
    return __awaiter(this, void 0, void 0, function* () {
        const prisma = context.dataSources.prisma;
        const { life_span, workout_name, excercise_set_groups } = previousWorkout;
        var previousExerciseSetGroups = excercise_set_groups;
        // Don't need progressive overload because it was NOT completed in previous workout (It was temporarily replaced or removed)
        const excercise_set_groups_without_progressive_overload = _.differenceWith(next_workout_excercise_set_groups, previousExerciseSetGroups, (x, y) => x.excercise_name === y.excercise_name);
        // Need progressive overload because it was completed in the previous workout
        const excercise_set_groups_to_progressive_overload = _.differenceWith(next_workout_excercise_set_groups, excercise_set_groups_without_progressive_overload, (x, y) => x.excercise_name === y.excercise_name);
        const progressively_overloaded_excercise_set_groups = yield (0, progressive_overloader_1.progressivelyOverload)(excercise_set_groups_to_progressive_overload, context);
        // Combine the excerciseSetGroups together and set them to back to normal operation
        const finalExcerciseSetGroups = excercise_set_groups_without_progressive_overload
            .concat(progressively_overloaded_excercise_set_groups)
            .map((e) => (Object.assign(Object.assign({}, e), { excercise_set_group_state: graphql_1.ExcerciseSetGroupState.NormalOperation })));
        // Create the workout and slot behind the rest of the queue.
        yield prisma.workout.create({
            data: {
                user_id: context.user.user_id,
                workout_name: workout_name,
                life_span: life_span - 1,
                order_index: yield (0, utils_1.getActiveWorkoutCount)(context),
                excercise_set_groups: {
                    create: (0, utils_1.formatExcerciseSetGroups)(finalExcerciseSetGroups),
                },
            },
        });
    });
}
exports.generateNextWorkout = generateNextWorkout;
//# sourceMappingURL=workout_generator.js.map