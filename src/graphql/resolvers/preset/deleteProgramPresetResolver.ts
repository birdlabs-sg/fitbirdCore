import { onlyCoach } from "../../../service/firebase/firebase_service";
import { AppContext } from "../../../types/contextType";
import { MutationDeleteProgramPresetArgs } from "../../../types/graphql";

export async function deleteProgramPreset(
  _: unknown,
  args: MutationDeleteProgramPresetArgs,
  context: AppContext
) {
  onlyCoach(context);
  const prisma = context.dataSources.prisma;
  const { programPreset_id } = args;

  await prisma.programPreset.delete({
    where: {
      programPreset_id: parseInt(programPreset_id),
    },
  });

  return {
    code: "200",
    success: true,
    message: "Successfully deleted a challenge preset!",
  };
}
