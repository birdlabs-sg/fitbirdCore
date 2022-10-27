import { QueryWorkoutsArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";
<<<<<<< Updated upstream
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";

=======
import {
  isUser,
  onlyAuthenticated,
  onlyCoach,
} from "../../../service/firebase/firebase_service";
import { WorkoutType } from "@prisma/client";
>>>>>>> Stashed changes
export async function workoutsQueryResolver(
  _: any,
  { filter, type }: QueryWorkoutsArgs,
  context: AppContext
) {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
<<<<<<< Updated upstream
  switch (filter) {
    case "ACTIVE":
      return await prisma.workout.findMany({
        where: {
          user_id: context.user.user_id,
          date_completed: null,
          workout_type: type ?? undefined,
        },
        orderBy: {
          order_index: "asc",
        },
      });
    case "COMPLETED":
      return await prisma.workout.findMany({
        where: {
          user_id: context.user.user_id,
          date_completed: { not: null },
          workout_type: type ?? undefined,
        },
        orderBy: {
          date_completed: "desc",
        },
      });
    case "NONE":
      return await prisma.workout.findMany({
        where: {
          user_id: context.user.user_id,
          workout_type: type ?? undefined,
        },
      });
    default:
      return [];
=======
  if (isUser(context)) {
    switch (filter) {
      case "ACTIVE":
        return await prisma.workout.findMany({
          where: {
            user_id: context.base_user.User!.user_id,
            date_completed: null,
            workout_type: type ?? undefined,
          },
          orderBy: {
            order_index: "asc",
          },
        });
      case "COMPLETED":
        return await prisma.workout.findMany({
          where: {
            user_id: context.base_user.User!.user_id,
            date_completed: { not: null },
            workout_type: type ?? undefined,
          },
          orderBy: {
            date_completed: "desc",
          },
        });
      case "NONE":
        return await prisma.workout.findMany({
          where: {
            user_id: context.base_user.User!.user_id,
            workout_type: type ?? undefined,
          },
        });
      default:
        return [];
    }
  } else {
    //onlyCoach(context)
    switch (filter) {
      case "ACTIVE":
        return await prisma.workout.findMany({
          where: {
            user_id: parseInt(user_id!),
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
            user_id: parseInt(user_id!),
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
            user_id: parseInt(user_id!),
            workout_type: WorkoutType.COACH_MANAGED,
          },
        });
      default:
        return [];
    }
>>>>>>> Stashed changes
  }
}
