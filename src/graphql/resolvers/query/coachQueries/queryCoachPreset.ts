
import { AppContext } from "../../../../types/contextType";
import { onlyCoach } from "../../../../service/firebase/firebase_service";
import { QueryCoachPresetArgs } from "../../../../types/graphql";
export const coachPresetQueryResolver = async (
  _: unknown,
  args: QueryCoachPresetArgs,
  context: AppContext
) => {
  onlyCoach(context)
  const prisma = context.dataSources.prisma;

  return await prisma.programPreset.findUnique({
    where: {
      programPreset_id: parseInt(args.preset_id),
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
