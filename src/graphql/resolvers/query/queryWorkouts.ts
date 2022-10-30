import { QueryWorkoutsArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";
import {
  isUser,
  onlyAuthenticated,
  onlyCoach,
} from "../../../service/firebase/firebase_service";
import { WorkoutType } from "@prisma/client";
export async function workoutsQueryResolver(
  _: unknown,
  { filter, type, user_id }: QueryWorkoutsArgs,
  context: AppContext
) {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;

  switch (filter) {
    case "ACTIVE":
      return await prisma.workout.findMany({
        where: {
          user_id: parseInt(user_id!) ?? context.user.user_id,
          date_completed: null,
          workout_type: type ?? undefined,
        },
        orderBy: {
          order_index: "asc",
        },
      })
    case "COMPLETED":
      return await prisma.workout.findMany({
        where: {
          user_id: parseInt(user_id!) ?? context.user.user_id,
          date_completed: { not: null },
          workout_type: type ?? undefined,
        },
        orderBy: {
          date_completed: "desc",
        },
      })
        
    case "NONE":
      return await prisma.workout.findMany({
        where: {
          user_id: parseInt(user_id!) ?? context.user.user_id,
          workout_type: type ?? undefined,
        },
      })
    default:
      return [];
  }
}
