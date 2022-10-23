import { AppContext } from "../../../../types/contextType";
import {
  onlyAuthenticated,
  onlyCoach,
} from "../../../../service/firebase/firebase_service";
import {
  getActiveProgram,
  getActiveWorkoutCount,
} from "../../../../service/workout_manager/utils";
import { MutationCreateProgramArgs } from "../../../../types/graphql";
import { formatExcerciseSetGroups } from "../../../../service/workout_manager/utils";
import { extractMetadatas } from "../../../../service/workout_manager/utils";
import { generateOrUpdateExcerciseMetadata } from "../../../../service/workout_manager/exercise_metadata_manager/exercise_metadata_manager";
import { ExcerciseSetGroupInput } from "../../../../types/graphql";
import { WorkoutType } from "@prisma/client";
import { resetActiveProgramsForCoaches } from "../../../../service/workout_manager/utils";
import { GraphQLError } from "graphql";
/*at any given time, there will only be one active program for the user,so
  //1. change all existing programs to is_active = false
  //2. set the new program to be active,
*/
export const createProgram = async (
  _: any,
  { user_id, workoutsInput }: MutationCreateProgramArgs,
  context: AppContext
) => {
  //onlyAuthenticated(context);
  onlyCoach(context);
  const prisma = context.dataSources.prisma;
  // Ensure that there is a max of 7 workouts
  
  if (workoutsInput!.length > 7) {
    throw Error("VALIDATE Must be no more than 7 workouts");
  } else {
    //1. Set all existing programs and its corresponding workouts to be inactive
    resetActiveProgramsForCoaches(context, WorkoutType.COACH_MANAGED, user_id);
    let workoutArray: any[] = [];

    //2.generate the list of workouts
    for (let i = 0; i < workoutsInput!.length; i++) {
      let { life_span, workout_name, excercise_set_groups, workout_type } =
        workoutsInput![i];
      const [excerciseSetGroups, excerciseMetadatas] = extractMetadatas(
        excercise_set_groups as ExcerciseSetGroupInput[]
      );

      await generateOrUpdateExcerciseMetadata(
        context,
        excerciseMetadatas,
        user_id
      );

      let formattedExcerciseSetGroups =
        formatExcerciseSetGroups(excercise_set_groups!);
      var date = new Date();
      date.setDate(date.getDate() + i);
      let workout_input: any = {
        user: { connect: { user_id: parseInt(user_id) } },
        date_scheduled: date,
        life_span: life_span,
        order_index: await getActiveWorkoutCount(
          context,
          workout_type,
          user_id
        ),
        workout_name: workout_name,
        workout_type: workout_type,
        excercise_set_groups: {
          create: formatExcerciseSetGroups(excercise_set_groups!),
        },
      };

      workoutArray.push(workout_input);
    }
    //3. Create the new program object with its corresponding workouts
    const workout = await prisma.program.create({
      data: {
        coach: { connect: { coach_id: context.coach.coach_id } },
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
