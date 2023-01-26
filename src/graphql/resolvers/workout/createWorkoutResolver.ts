import { GraphQLError } from "graphql";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import {
  extractMetadatas,
  formatExcerciseSetGroups,
} from "../../../service/workout_manager/utils";
import { getActiveWorkout } from "../../../service/workout_manager/utils";
import { AppContext } from "../../../types/contextType";
import { MutationCreateWorkoutArgs } from "../../../types/graphql";
import { generateOrUpdateExcerciseMetadata } from "../../../service/workout_manager/exercise_metadata_manager/exercise_metadata_manager";
import { checkExistsAndOwnershipOnSharedResource } from "../program/deleteProgramResolver";

/**
 * Creates a new workout.
 */
export async function createWorkoutResolver(
  _: unknown,
  {
    excercise_set_groups,
    date_scheduled,
    workout_name,
    program_id,
  }: MutationCreateWorkoutArgs,
  context: AppContext
) {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const programAffected = await prisma.program.findFirstOrThrow({
    where: {
      program_id: parseInt(program_id),
    },
  });
  checkExistsAndOwnershipOnSharedResource({
    context: context,
    object: programAffected,
  });

  // Ensure that there is a max of 7 workouts
  const { count } = await getActiveWorkout({
    context: context,
    program_id: program_id,
  });
  if (count > 7) {
    throw new GraphQLError("You can only have 7 active workouts.", {
      extensions: {
        code: "FORBIDDEN",
      },
    });
  }

  const [cleaned_excercise_set_groups, excercise_metadatas] =
    extractMetadatas(excercise_set_groups);
  await generateOrUpdateExcerciseMetadata({
    context,
    excercise_metadatas,
  });

  const formattedExcerciseSetGroups = formatExcerciseSetGroups(
    cleaned_excercise_set_groups
  );

  const workout = await prisma.workout.create({
    data: {
      programProgram_id: parseInt(program_id),
      workout_name: workout_name,
      date_scheduled: date_scheduled,
      excercise_set_groups: {
        create: formattedExcerciseSetGroups,
      },
    },
  });

  return {
    code: "200",
    success: true,
    message: "Successfully created a workout.",
    workout: workout!,
  };
}
