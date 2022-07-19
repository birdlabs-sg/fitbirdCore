import { onlyAuthenticated } from "../../../service/firebase_service";

export const workoutsQueryResolver = async (
  parent: any,
  args: any,
  context: any,
  info: any
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  switch (args.filter) {
    case "ACTIVE":
      return await prisma.workout.findMany({
        where: {
          user_id: context.user.user_id,
          date_completed: null,
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
        },
        orderBy: {
          date_completed: "asc",
        },
      });
    case "NONE":
      return await prisma.workout.findMany({
        where: {
          user_id: context.user.user_id,
        },
      });
  }
};
