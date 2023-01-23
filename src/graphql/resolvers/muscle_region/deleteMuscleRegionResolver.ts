import { AppContext } from "../../../types/contextType";
import { MutationDeleteMuscleRegionArgs } from "../../../types/graphql";
import {
  onlyAdmin,
  onlyAuthenticated,
} from "../../../service/firebase/firebase_service";

export const deleteMuscleRegionResolver = async (
  _: unknown,
  { muscle_region_id }: MutationDeleteMuscleRegionArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  onlyAdmin(context);
  const prisma = context.dataSources.prisma;
  const deletedMuscleRegion = await prisma.muscleRegion.delete({
    where: {
      muscle_region_id: parseInt(muscle_region_id),
    },
  });
  return {
    code: "200",
    success: true,
    message: "Successfully removed your measurement!",
    muscle_region: deletedMuscleRegion,
  };
};
