import { onlyCoach } from "../../../../service/firebase/firebase_service";
import { AppContext } from "../../../../types/contextType";
import {
  MutationUpdateWorkoutArgs,
  ExcerciseSetGroupInput,
} from "../../../../types/graphql";
import {
  extractMetadatas,
  formatExcerciseSetGroups,
  retrieveUserIdFromWorkout,
  validateCoachAndUser,
} from "../../../../service/workout_manager/utils";
import { generateOrUpdateExcerciseMetadata } from "../../../../service/workout_manager/exercise_metadata_manager/exercise_metadata_manager";
/* function to update the next workout in the program */
export const updateWorkoutInProgram = async (
  _: any,
  { workout_id, excercise_set_groups, ...otherArgs }: MutationUpdateWorkoutArgs,
  context: AppContext
) => {
  onlyCoach(context);
  const prisma = context.dataSources.prisma;
  await validateCoachAndUser(context, workout_id);
  let formatedUpdatedData;
  if (excercise_set_groups != null) {
    var [excerciseSetGroups, excercise_metadatas] = extractMetadatas(
      excercise_set_groups as ExcerciseSetGroupInput[]
    );
    formatedUpdatedData = {
      ...otherArgs,
      ...{
        excercise_set_groups: {
          deleteMany: {},
          create: formatExcerciseSetGroups(excerciseSetGroups),
        },
      },
    };
    let user_id = await retrieveUserIdFromWorkout(context, workout_id);
    await generateOrUpdateExcerciseMetadata(
      context,
      excercise_metadatas,
      user_id.toString()
    );// BLOCKER: unsure if this is the safest way for parsing generateOrUpdateExcerciseMetadata
  } else {
    formatedUpdatedData = {
      ...otherArgs,
    };
  }
  // extract out metadatas
  const updatedWorkout = await prisma.workout.update({
    where: {
      workout_id: parseInt(workout_id),
    },
    data: formatedUpdatedData,
    include: {
      excercise_set_groups: { include: { excercise_sets: true } },
    },
  });

  return {
    code: "200",
    success: true,
    message: "Successfully updated your workout!",
    workout: updatedWorkout,
  };
};

