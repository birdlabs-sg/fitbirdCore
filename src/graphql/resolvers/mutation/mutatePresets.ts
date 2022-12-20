import { onlyAuthenticated, onlyCoach } from "../../../service/firebase/firebase_service";
import { AppContext } from "../../../types/contextType";
import { formatPresetWorkoutsIntoPresetMutationReq } from "../../../service/workout_manager/utils";
import { MutationCreateProgramPresetArgs, MutationDeleteProgramPresetArgs } from "../../../types/graphql";
import { GraphQLError } from "graphql";
// create a preset from coach
export async function createProgramPreset(
  _: unknown,
  args: MutationCreateProgramPresetArgs,
  context: AppContext
) {
  onlyCoach(context)
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const { preset_workouts, preset_name,life_span, preset_difficulty,image_url } = args;
  if(preset_workouts.length!==7){
    throw new GraphQLError("Must have 7 preset workouts");
  }
  const formattedPresetWorkouts = formatPresetWorkoutsIntoPresetMutationReq(preset_workouts)
  await prisma.programPreset.create({
    data: {
      preset_workouts: { create: formattedPresetWorkouts },
      preset_name: preset_name,
      life_span: life_span,
      preset_difficulty: preset_difficulty,
      image_url:image_url,
      coach: { connect: { coach_id: context.base_user!.coach!.coach_id } },
    },
  });
  
  return {
    code: "200",
    success: true,
    message: "Successfully created a challenge preset!",
  }
}


export async function deleteProgramPreset(
  _: unknown,
  args:MutationDeleteProgramPresetArgs,
  context: AppContext
){
onlyCoach(context)
const prisma = context.dataSources.prisma;
const {programPreset_id} = args

await prisma.programPreset.delete({
  where:{
    programPreset_id:parseInt(programPreset_id)
  }
})

return {
  code: "200",
  success: true,
  message: "Successfully deleted a challenge preset!",
}
}