import { AppContext } from "../../../../types/contextType";
import { onlyCoach } from "../../../../service/firebase/firebase_service";
import {
  getActiveProgram,
  getActiveWorkoutCount,
} from "../../../../service/workout_manager/utils";
import {
  MutationCreateProgramArgs,
} from "../../../../types/graphql";
import { formatExcerciseSetGroups } from "../../../../service/workout_manager/utils";
import { extractMetadatas } from "../../../../service/workout_manager/utils";
import { generateOrUpdateExcerciseMetadata } from "../../../../service/workout_manager/exercise_metadata_manager/exercise_metadata_manager";
import { ExcerciseSetGroupInput } from "../../../../types/graphql";
import { Workout, WorkoutType } from "@prisma/client";
import { resetActiveProgramsForCoaches } from "../../../../service/workout_manager/utils";
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
        life_span: life_span!-1,
        order_index: await getActiveWorkoutCount(
          context,
          workout_type,
          user_id
        )+i,
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
