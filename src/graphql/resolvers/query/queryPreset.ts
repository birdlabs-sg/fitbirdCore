
import { QueryChallengePresetArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";

export const presetQueryResolver = async (
  _: unknown,
  args: QueryChallengePresetArgs,
  context: AppContext
) => {
  const prisma = context.dataSources.prisma;

  return await prisma.challengePreset.findUnique({
    where: {
      challengePreset_id: parseInt(args.preset_id),
    },
    include:{
      preset_workouts:{
        include:{
          preset_excercise_set_groups:{
            include:{
              preset_excercise_sets:true
            }
          }
        }
      }
    }
  });
};
