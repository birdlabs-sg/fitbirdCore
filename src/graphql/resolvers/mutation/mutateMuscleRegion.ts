import { AppContext } from "../../../types/contextType";
import { MutationUpdateMuscleRegionArgs } from "../../../types/graphql";
import { MutationDeleteMuscleRegionArgs } from "../../../types/graphql";
import { MutationCreateMuscleRegionArgs } from "../../../types/graphql";
import {
  onlyAdmin,
  onlyAuthenticated,
} from "../../../service/firebase/firebase_service";

export const createMuscleRegion = async (
  _: any,
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

export const updateMuscleRegion = async (
  _: any,
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

export const deleteMuscleRegion = async (
  _: any,
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
