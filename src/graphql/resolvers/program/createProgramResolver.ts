import { Prisma, ProgramType } from "@prisma/client";
import { AppContext } from "../../../types/contextType";
import { MutationCreateProgramArgs } from "../../../types/graphql";
import {
  extractMetadatas,
  formatExcerciseSetGroups,
} from "../../../service/workout_manager/utils";
import { generateOrUpdateExcerciseMetadata } from "../../../service/workout_manager/exercise_metadata_manager/exercise_metadata_manager";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { clientCoachRelationshipGuard, getStakeHoldersID } from "../utils";
import { GraphQLError } from "graphql";

export const createProgramResolver = async (
  _: unknown,
  { user_id, coach_id, workoutsInput, program_type }: MutationCreateProgramArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  if (program_type == ProgramType.COACH_MANAGED && !coach_id) {
    throw new GraphQLError("Coached managed programs must pass in coach_id.");
  }
  const stakeholderIds = getStakeHoldersID({
    context: context,
    user_id: user_id,
    coach_id: coach_id,
  });
  if (stakeholderIds.user_id == null) {
    throw new GraphQLError(
      "user_id is required, however we were unable to infer it."
    );
  }
  if (stakeholderIds.requestor_type == "COACH") {
    await clientCoachRelationshipGuard({
      context,
      user_id: parseInt(stakeholderIds.user_id),
      coach_id: parseInt(stakeholderIds.coach_id),
    });
  }
  const prisma = context.dataSources.prisma;
  // Ensure that there is a max of 7 workouts
  if (workoutsInput!.length > 7) {
    throw Error("VALIDATE Must be no more than 7 workouts");
  }
  const workoutArray: Prisma.WorkoutCreateWithoutProgramInput[] = [];
  for (let i = 0; i < workoutsInput.length; i++) {
    const [prismaExerciseSetGroupCreateArgs, excercise_metadatas] =
      extractMetadatas(workoutsInput[i].excercise_set_groups);

    await generateOrUpdateExcerciseMetadata({
      context,
      excercise_metadatas,
      user_id: stakeholderIds.user_id,
    });
    const workout_input: Prisma.WorkoutCreateWithoutProgramInput = {
      ...workoutsInput[i],
      excercise_set_groups: {
        create: formatExcerciseSetGroups(prismaExerciseSetGroupCreateArgs),
      },
    };
    workoutArray.push(workout_input);
  }

  //3. Create the new program object with its corresponding workouts
  const program = await prisma.program.create({
    data: {
      ...(stakeholderIds.coach_id && {
        coach: { connect: { coach_id: parseInt(stakeholderIds.coach_id) } },
      }),
      program_type: program_type,
      user: { connect: { user_id: parseInt(stakeholderIds.user_id) } },
      is_active: true,
      workouts: {
        create: workoutArray,
      },
    },
  });

  return {
    code: "200",
    success: true,
    message: "Successfully Created your program!",
    program: program!,
  };
};
