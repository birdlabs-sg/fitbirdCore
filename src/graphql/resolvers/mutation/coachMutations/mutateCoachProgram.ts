import { AppContext } from "../../../../types/contextType";
import {
  onlyCoach,
  onlyAuthenticated,
} from "../../../../service/firebase/firebase_service";
import {
  getActiveProgram,
  getActiveWorkoutCount,
} from "../../../../service/workout_manager/utils";
import { MutationCreateProgramArgs, MutationLoadProgramFromPresetArgs } from "../../../../types/graphql";
import { formatExcerciseSetGroups } from "../../../../service/workout_manager/utils";
import { extractMetadatas } from "../../../../service/workout_manager/utils";
import { generateOrUpdateExcerciseMetadata } from "../../../../service/workout_manager/exercise_metadata_manager/exercise_metadata_manager";
import { ExcerciseSetGroupInput } from "../../../../types/graphql";
import { Workout, WorkoutType } from "@prisma/client";
import { resetActiveProgramsForCoaches } from "../../../../service/workout_manager/utils";
import { convertPresetIntoExcerciseSetGroups } from "../../../../service/workout_manager/utils";
/*at any given time, there will only be one active program for the user,so
  //1. change all existing programs to is_active = false
  //2. set the new program to be active,
*/
export const createProgram = async (
  _: unknown,
  { user_id, workoutsInput }: MutationCreateProgramArgs,
  context: AppContext
) => {
  onlyCoach(context);
  const prisma = context.dataSources.prisma;
  // Ensure that there is a max of 7 workouts

  if (workoutsInput!.length > 7) {
    throw Error("VALIDATE Must be no more than 7 workouts");
  } else {
    const workoutArray: Workout[] = [];
    //2. Set all existing programs and its corresponding workouts to be inactive
    resetActiveProgramsForCoaches(context, WorkoutType.COACH_MANAGED, user_id);
    //3.generate the list of workouts
    for (let i = 0; i < workoutsInput.length; i++) {
      const {
        life_span,
        workout_name,
        excercise_set_groups,
        workout_type,
        date_scheduled,
      } = workoutsInput[i];
      const [_, excerciseMetadatas] = extractMetadatas(
        excercise_set_groups as ExcerciseSetGroupInput[]
      );

      await generateOrUpdateExcerciseMetadata(
        context,
        excerciseMetadatas,
        user_id
      );

      let workout_input: any = {
        user: { connect: { user_id: parseInt(user_id) } },
        date_scheduled: date_scheduled,
        life_span: life_span! - 1,
        order_index:
          (await getActiveWorkoutCount(context, workout_type, user_id)) + i,
        workout_name: workout_name,
        workout_type: workout_type,
        excercise_set_groups: {
          create: formatExcerciseSetGroups(excercise_set_groups!),
        },
      };

      workoutArray.push(workout_input);
    }

    //3. Create the new program object with its corresponding workouts

    await prisma.program.create({
      data: {
        coach: { connect: { coach_id: context.base_user!.coach!.coach_id } },
        user: { connect: { user_id: parseInt(user_id) } },
        is_active: true,
        workouts: {
          create: workoutArray,
        },
      },
    });
  }
  return {
    code: "200",
    success: true,
    message: "Successfully Created your program!",
    program: await getActiveProgram(context, user_id),
  };
};

export const endActiveProgram = async (
  _: unknown,
  args: any,
  context: AppContext
) => {
  onlyCoach(context);
  const { user_id } = args;
  resetActiveProgramsForCoaches(context, WorkoutType.COACH_MANAGED, user_id);
  return {
    code: "200",
    success: true,
    message: "Successfully ended active program!",
    program: await getActiveProgram(context, user_id),
  };
};


//TO DO: fix and implement
export async function loadProgramFromPreset(
  _: unknown,
  args: MutationLoadProgramFromPresetArgs,
  context: AppContext
) {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const { programPreset_id, user_id,start_date } = args;
  let workouts: Workout[] = [];
  //1. load preset
  const preset = await prisma.programPreset.findFirst({
    where: {
      programPreset_id: parseInt(programPreset_id),
    },
    include: {
      preset_workouts: {
        include: {
          preset_excercise_set_groups: {
            include: {
              preset_excercise_sets: true,
            },
          },
        },
      },
    },
  });
  // 2. set all existing programs to be inactive
  resetActiveProgramsForCoaches(context, WorkoutType.COACH_MANAGED, user_id);
  // 3. create workout array, preset_workouts length should be 7, push into arrat only if not rest day
  for (let i = 0; i < preset.preset_workouts.length; i++) {
    if(!preset.preset_workouts[i].rest_day){
      var newDate = new Date(start_date)
      newDate.setDate(newDate.getDate() + i);
      let workout: any = {
        user: { connect: { user_id: context.base_user.User.user_id } },
        workout_type: WorkoutType.COACH_MANAGED,
        workout_name: preset.preset_name,
        date_scheduled:newDate,
        life_span: preset.life_span, //life_span to be confirmed 1/0 <--
        order_index: i + 1,
        excercise_set_groups: {
          create: convertPresetIntoExcerciseSetGroups(
            preset.preset_workouts[i].preset_excercise_set_groups
          ),
        },
       
      };
      workouts.push(workout);
    }
  }
  // 4. create the program with the workouts
  await prisma.program.create({
    data: {
      workouts: { create: workouts },
      is_active: true,
      user: { connect: { user_id: context.base_user.User.user_id } },
      coach: { connect: { coach_id: context.base_user!.coach!.coach_id } },
    },
  });

  return {
    code: "200",
    success: true,
    message: "Successfully created a challenge.",
  };
}
