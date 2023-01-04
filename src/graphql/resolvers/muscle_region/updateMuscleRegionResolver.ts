import { AppContext } from "../../../types/contextType";
import { MutationUpdateMuscleRegionArgs } from "../../../types/graphql";
import {
  onlyAdmin,
  onlyAuthenticated,
} from "../../../service/firebase/firebase_service";

export const updateMuscleRegionResolver = async (
  _: unknown,
  args: MutationUpdateMuscleRegionArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  onlyAdmin(context);
  const { muscle_region_id, ...otherArgs } = args;
  const prisma = context.dataSources.prisma;
  const updatedMuscleRegion = await prisma.muscleRegion.update({
    where: {
      muscle_region_id: parseInt(muscle_region_id),
    },
    data: otherArgs,
  });
  return {
    code: "200",
    success: true,
    message: "Successfully updated your measurement!",
    muscle_region: updatedMuscleRegion,
  };
};
