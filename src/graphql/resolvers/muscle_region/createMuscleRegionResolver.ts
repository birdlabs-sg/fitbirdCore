import { AppContext } from "../../../types/contextType";
import { MutationCreateMuscleRegionArgs } from "../../../types/graphql";
import {
  onlyAdmin,
  onlyAuthenticated,
} from "../../../service/firebase/firebase_service";

export const createMuscleRegionResolver = async (
  _: unknown,
  args: MutationCreateMuscleRegionArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  onlyAdmin(context);
  const prisma = context.dataSources.prisma;
  const newMuscleRegion = await prisma.muscleRegion.create({
    data: args,
  });

  return {
    code: "200",
    success: true,
    message: "Successfully created a muscle region!",
    muscle_region: newMuscleRegion,
  };
};
