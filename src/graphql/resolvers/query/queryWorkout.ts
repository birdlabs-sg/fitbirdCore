import { onlyAuthenticated } from "../../../service/firebase_service";

export const workoutQueryResolver = async (
  parent: any,
  args: any,
  context: any,
  info: any
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const { workout_id } = args;
  return await prisma.workout.findUnique({
    where: {
      workout_id: parseInt(workout_id),
    },
  });
};
