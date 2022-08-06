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

  const excerciseSetGroups = await prisma.excerciseSetGroup.findMany({
    where: {
      workout: {
        user_id: context.user.user_id,
        date_completed: { not: null },
      },
      excercise_name: excercise_name,
    },
    include: { workout: true, excercise_sets: true },
    orderBy: {
      workout: {
        date_completed: "desc",
      },
    },
    take: span,
  });

  for (var excerciseSetGroup of excerciseSetGroups) {
    grouped_excercise_sets.push({
      date_completed: excerciseSetGroup.workout.date_completed,
      excercise_sets: excerciseSetGroup.excercise_sets,
    });
  }

  return { grouped_excercise_sets: grouped_excercise_sets };
};
