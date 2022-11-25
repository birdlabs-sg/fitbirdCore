import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { AppContext } from "../../../types/contextType";
export async function createChallengePreset(
  _: unknown,
  args: any,
  context: AppContext
) {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const { preset_Workouts, preset_name, duration, preset_difficulty } = args;
  const challengePreset = await prisma.challengePreset.create({
    data: {
      preset_Workouts: { create: preset_Workouts },
      preset_name: preset_name,
      duration: duration,
      preset_difficulty: preset_difficulty,
    },
  });
  
  return {
    code: "200",
    success: true,
    message: "Successfully created a challenge preset!",
    privateMessage: challengePreset,
  }
}
