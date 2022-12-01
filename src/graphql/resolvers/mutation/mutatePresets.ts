import {MutationCreateChallengePresetArgs } from "../../../types/graphql";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { AppContext } from "../../../types/contextType";
import { formatPresetWorkoutsIntoPresetMutationReq } from "../../../service/workout_manager/utils";
export async function createChallengePreset(
  _: unknown,
  args: MutationCreateChallengePresetArgs,
  context: AppContext
) {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const { preset_Workouts, preset_name, duration, preset_difficulty,image_url } = args;
  const formattedPresetWorkouts = formatPresetWorkoutsIntoPresetMutationReq(preset_Workouts)
  await prisma.challengePreset.create({
    data: {
      preset_workouts: { create: formattedPresetWorkouts },
      preset_name: preset_name,
      duration: duration,
      preset_difficulty: preset_difficulty,
      image_url:image_url
    },
  });
  
  return {
    code: "200",
    success: true,
    message: "Successfully created a challenge preset!",
  }
}
