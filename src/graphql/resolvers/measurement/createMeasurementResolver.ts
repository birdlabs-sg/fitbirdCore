import { AppContext } from "../../../types/contextType";
import { MutationCreateMeasurementArgs } from "../../../types/graphql";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";

export const createMeasurementResolver = async (
  _: unknown,
  args: MutationCreateMeasurementArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const { muscle_region_id, ...otherArgs } = args;
  const newMeasurement = await prisma.measurement.create({
    data: {
      ...otherArgs,
      muscle_region: {
        connect: { muscle_region_id: parseInt(muscle_region_id) },
      },
      user: {
        connect: { user_id: context.base_user!.User!.user_id },
      },
    },
    include: {
      muscle_region: true,
    },
  });
  return {
    code: "200",
    success: true,
    message: "Successfully recorded your measurement!",
    measurement: newMeasurement,
  };
};
