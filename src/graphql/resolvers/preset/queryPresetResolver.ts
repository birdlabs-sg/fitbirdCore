import { AppContext } from "../../../types/contextType";
import { onlyCoach } from "../../../service/firebase/firebase_service";
import { QueryPresetArgs } from "../../../types/graphql";
export const presetQueryResolver = async (
  _: unknown,
  args: QueryPresetArgs,
  context: AppContext
) => {
  onlyCoach(context);
  const prisma = context.dataSources.prisma;

  return await prisma.programPreset.findUniqueOrThrow({
    where: {
      programPreset_id: parseInt(args.programPreset_id),
    },
    include: {
      preset_workouts: {
        include: {
          preset_excercise_set_groups: {
            include: {
              preset_excercise_sets: true,
            },
          },
        },
      },
    },
  });
};
