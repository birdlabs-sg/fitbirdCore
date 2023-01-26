import { QueryGetExcercisePerformanceArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { ExcerciseSet } from "@prisma/client";

type performanceObject = {
  date_completed: Date | null;
  excercise_sets: ExcerciseSet[] | null;
};
export const excercisePerformanceQueryResolver = async (
  _: unknown,
  { excercise_name, span }: QueryGetExcercisePerformanceArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;

  if (span == null) {
    span = 1;
  }

  const grouped_excercise_sets: performanceObject[] = [];

  const excerciseSetGroups = await prisma.excerciseSetGroup.findMany({
    where: {
      workout: {
        Program: {
          user_id: context.base_user?.User?.user_id,
        },
        date_closed: { not: null },
      },
      excercise_name: excercise_name,
    },
    include: { workout: true, excercise_sets: true },
    orderBy: {
      workout: {
        date_closed: "desc",
      },
    },
    take: span,
  });

  for (const excerciseSetGroup of excerciseSetGroups) {
    grouped_excercise_sets.push({
      date_completed: excerciseSetGroup.workout.date_closed,
      excercise_sets: excerciseSetGroup.excercise_sets,
    });
  }

  return { grouped_excercise_sets: grouped_excercise_sets };
};
