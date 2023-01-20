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
import { ProgramType } from "@prisma/client";
import { clientCoachRelationshipGuard } from "../program/utils";

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
    coach_id,
    user_id,
  }: MutationCreateWorkoutArgs,
  context: AppContext
) {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const program = await prisma.program.findUniqueOrThrow({
    where: {
      program_id: parseInt(program_id),
    },
  });
  if (program.program_type === ProgramType.COACH_MANAGED && !coach_id) {
    throw new GraphQLError("Coached managed workouts must pass in coach_id.");
  }

  await clientCoachRelationshipGuard({
    context,
    user_id: parseInt(user_id),
    coach_id: coach_id ? parseInt(coach_id) : null,
    checkRelationship: true,
    onlyAllowActiveRelationship: true,
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

  const workout = await prisma.workout
    .create({
      data: {
        programProgram_id: parseInt(program_id),
        workout_name: workout_name,
        date_scheduled: date_scheduled,
        excercise_set_groups: {
          create: formattedExcerciseSetGroups,
        },
      },
    })
    .catch((e) => console.log(e));

  console.log(workout);

  return {
    code: "200",
    success: true,
    message: "Successfully created a workout.",
    workout: workout!,
  };
}
