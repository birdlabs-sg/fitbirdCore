import { AppContext } from "../../../types/contextType";
import { MutationDeleteMeasurementArgs } from "../../../types/graphql";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { GraphQLError } from "graphql";

export const deleteMeasurementResolver = async (
  _: unknown,
  args: MutationDeleteMeasurementArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const { measurement_id } = args;

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
    throw new GraphQLError("You are not authororized to remove this object.");
  }

  const deletedMeasurement = await prisma.measurement.delete({
    where: {
      measurement_id: parseInt(measurement_id),
    },
  });
  return {
    code: "200",
    success: true,
    message: "Successfully removed your measurement!",
    measurement: deletedMeasurement,
  };
};
