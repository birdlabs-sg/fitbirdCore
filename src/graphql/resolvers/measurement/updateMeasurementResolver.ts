import { AppContext } from "../../../types/contextType";
import { MutationUpdateMeasurementArgs } from "../../../types/graphql";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { GraphQLError } from "graphql";

export const updateMeasurementResolver = async (
  _: unknown,
  args: MutationUpdateMeasurementArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const { measurement_id, ...otherArgs } = args;
  const prisma = context.dataSources.prisma;

  // conduct check that the measurement object belongs to the user.
  const targetMeasurement = await prisma.measurement.findUnique({
    where: {
      measurement_id: parseInt(measurement_id),
    },
  });
  if (
    targetMeasurement != null &&
    targetMeasurement.user_id !== context.base_user!.User!.user_id
  ) {
    throw new GraphQLError("You are not authororized to mutate this object.");
  }

  const updatedMeasurement = await prisma.measurement.update({
    where: {
      measurement_id: parseInt(measurement_id),
    },
    data: otherArgs,
    include: {
      muscle_region: true,
    },
  });
  return {
    code: "200",
    success: true,
    message: "Successfully updated your measurement!",
    measurement: updatedMeasurement,
  };
};
