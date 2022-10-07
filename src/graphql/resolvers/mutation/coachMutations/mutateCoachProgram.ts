import { AppContext } from "../../../../types/contextType";
import { onlyCoach } from "../../../../service/firebase/firebase_service";
import { getActiveProgram } from "../../../../service/workout_manager/utils";
import { MutationCreateProgramArgs } from "../../../../types/graphql";
import {
  formatExcerciseSetGroups,
  getActiveWorkoutCount,
} from "../../../../service/workout_manager/utils";
import { extractMetadatas } from "../../../../service/workout_manager/utils";
import { generateOrUpdateExcerciseMetadata } from "../../../../service/workout_manager/exercise_metadata_manager/exercise_metadata_manager";
import { ExcerciseSetGroupInput } from "../../../../types/graphql";


/*at any given time, there will only be one active program for the user,so
  //1. change all existing programs to is_active = false
  //2. set the new program to be active,
*/
export const createProgram = async (
  _: any,
  { user_id, workouts }: MutationCreateProgramArgs,
  context: AppContext
) => {
  onlyCoach(context);
  const setInactive = await prisma.program.update({
    where: {
      user_id: user_id,
      coach_id: context.coach.coach_id,
    },
    data: {
      is_active: false,
    },
  });

  for (let i = 0; i < workouts.length; i++) {
    let { life_span, workout_name, workout_type, excercise_set_groups } =
      workouts[i];
    const [excerciseSetGroups, excerciseMetadatas] = extractMetadatas(
      excercise_set_groups as ExcerciseSetGroupInput[]
    );

    const formattedExcerciseSetGroups =
      formatExcerciseSetGroups(excerciseSetGroups);

    const workout = await prisma.program.create({
      data: {
        coach_id: context.coach.coach_id,
        user_id: user_id,
        workout: {
          create: [
            {
              user_id: context.user.user_id,
              order_index: await getActiveWorkoutCount(
                context,
                workout_type,
                user_id
              ), // BLOCKER: unsure if this is the safest way for parsing getActiveWorkoutCount
              life_span: life_span,
              workout_name: workout_name,
              workout_type: workout_type,
              excercise_set_groups: {
                create: formattedExcerciseSetGroups,
              },
            },
          ],
        },
      },
    });

    await generateOrUpdateExcerciseMetadata(
      context,
      excerciseMetadatas,
      user_id
    ); // BLOCKER: unsure if this is the safest way for parsing generateOrUpdateExcerciseMetadata
  }

  return {
    code: "200",
    success: true,
    message: "Successfully updated your workout!",
    program: await getActiveProgram(context, user_id),
  };
};
