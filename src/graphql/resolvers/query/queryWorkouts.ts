import { QueryWorkoutsArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";

export async function workoutsQueryResolver(
  _: any,
  { filter, type }: QueryWorkoutsArgs,
  context: AppContext
) {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
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
  }
}
