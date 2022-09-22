import { ForbiddenError } from "apollo-server";
import { AppContext } from "../../../types/contextType";
import { MutationUpdateMeasurementArgs } from "../../../types/graphql";
import { MutationDeleteMeasurementArgs } from "../../../types/graphql";
import { MutationCreateMeasurementArgs } from "../../../types/graphql";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";

export const createMeasurement = async (
  _: any,
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
        connect: { user_id: context.user.user_id },
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

export const updateMeasurement = async (
  _: any,
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
    targetMeasurement.user_id !== context.user.user_id
  ) {
    throw new ForbiddenError("You are not authororized to mutate this object.");
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

export const deleteMeasurement = async (
  _: any,
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
    targetMeasurement.user_id !== context.user.user_id
  ) {
    throw new ForbiddenError("You are not authororized to remove this object.");
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
