import {
  QueryCoachWorkoutsArgs,
  QueryWorkoutsArgs,
} from "../../../../types/graphql";
import { AppContext } from "../../../../types/contextType";
import {
  onlyAuthenticated,
  onlyCoach,
} from "../../../../service/firebase/firebase_service";
import { WorkoutType } from "@prisma/client";

export async function coachWorkoutsQueryResolver(
  _: any,
  { filter, user_id }: QueryCoachWorkoutsArgs,
  context: AppContext
) {
  onlyCoach(context);
  const prisma = context.dataSources.prisma;
  switch (filter) {
    case "ACTIVE":
      return await prisma.workout.findMany({
        where: {
          user_id: parseInt(user_id),
          date_completed: null,
          workout_type: WorkoutType.COACH_MANAGED,
        },
        orderBy: {
          order_index: "asc",
        },
      });
    case "COMPLETED":
      return await prisma.workout.findMany({
        where: {
          user_id: parseInt(user_id),
          date_completed: { not: null },
          workout_type: WorkoutType.COACH_MANAGED,
        },
        orderBy: {
          date_completed: "desc",
        },
      });
    case "NONE":
      return await prisma.workout.findMany({
        where: {
          user_id: parseInt(user_id),
          workout_type: WorkoutType.COACH_MANAGED,
        },
      });
    default:
      return [];
  }
}
