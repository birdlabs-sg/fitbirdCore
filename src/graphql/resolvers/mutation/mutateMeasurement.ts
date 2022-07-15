import { ForbiddenError } from "apollo-server";
import { onlyAuthenticated } from "../../../service/firebase_service";

export const createMeasurement = async (_: any, args: any, context: any) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const { muscle_region_id, ...otherArgs } = args;
  const newMeasurement = await prisma.measurement.create({
    data: {
      ...otherArgs,
      muscle_region: {
        connect: { muscle_region_id: muscle_region_id },
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

export const updateMeasurement = async (_: any, args: any, context: any) => {
  onlyAuthenticated(context);
  const { measurement_id, ...otherArgs } = args;
  const prisma = context.dataSources.prisma;

  // conduct check that the measurement object belongs to the user.
  const targetMeasurement = await prisma.measurement.findUnique({
    where: {
      measurement_id: measurement_id,
    },
  });
  if (targetMeasurement.user_id !== context.user.user_id) {
    throw new ForbiddenError("You are not authororized to mutate this object.");
  }

  const updatedMeasurement = await prisma.measurement.update({
    where: {
      measurement_id: measurement_id,
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

export const deleteMeasurement = async (_: any, args: any, context: any) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;

  // conduct check that the measurement object belongs to the user.
  const targetMeasurement = await prisma.measurement.findUnique({
    where: {
      measurement_id: args.measurement_id,
    },
  });
  if (targetMeasurement.user_id !== context.user.user_id) {
    throw new ForbiddenError("You are not authororized to remove this object.");
  }

  const deletedMeasurement = await prisma.measurement.delete({
    where: {
      measurement_id: args.measurement_id,
    },
  });
  return {
    code: "200",
    success: true,
    message: "Successfully removed your measurement!",
    measurement: deletedMeasurement,
  };
};
