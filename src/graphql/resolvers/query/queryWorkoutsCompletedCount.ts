import { onlyAuthenticated } from "../../../service/firebase_service";

export const getWorkoutsCompletedCountQueryResolver = async (
  parent: any,
  args: any,
  context: any,
  info: any
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const { workout_group_id } = args;
  const workout_group = await prisma.workoutGroup.findUnique({
    where: {
      workout_group_id: parseInt(workout_group_id),
    },
    include: {
      workouts: true,
    },
  });
  console.log(workout_group);
  return workout_group.workouts.length;
};
