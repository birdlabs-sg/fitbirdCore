import { QueryGetWorkoutArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";

export const workoutQueryResolver = async (
  _: any,
  args: QueryGetWorkoutArgs,
  context: AppContext
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
