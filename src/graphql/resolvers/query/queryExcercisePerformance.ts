import { onlyAuthenticated } from "../../../service/firebase_service";

export const excercisePerformanceQueryResolver = async (
  parent: any,
  args: any,
  context: any,
  info: any
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;

  let { excercise_name, span } = args;

  if (span == null) {
    span = 1;
  }

  const grouped_excercise_sets = [];

  const workouts = await prisma.workout.findMany({
    where: {
      user_id: context.user.user_id,
      date_completed: { not: null },
      excercise_sets: {
        some: {
          excercise_name: excercise_name,
        },
      },
    },
    take: span,
    include: {
      excercise_sets: true,
    },
    orderBy: {
      date_completed: "desc",
    },
  });

  for (var workout of workouts) {
    grouped_excercise_sets.push({
      date_completed: workout.date_completed,
      excercise_sets: workout.excercise_sets.filter(
        (set: any) => set.excercise_name == excercise_name
      ),
    });
  }

  return { grouped_excercise_sets: grouped_excercise_sets };
};