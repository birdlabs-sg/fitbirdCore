import { AppContext } from "../../../types/contextType";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import {
  QueryAnalyticsExerciseOneRepMaxArgs,
  QueryAnalyticsExerciseTotalVolumeArgs,
} from "../../../types/graphql";

// Averaged Brzycki formula: weight * (1+reps/30)
export async function analyticsExerciseOneRepMaxResolver(
  _: unknown,
  { excercise_names_list, user_id }: QueryAnalyticsExerciseOneRepMaxArgs,
  context: AppContext
) {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const final_user_id =
    user_id == undefined ? context.base_user!.User!.user_id : parseInt(user_id);
  // queries completed workouts that has at least 1 exercise set group that appear in the excercise_name_list
  const workouts = await prisma.workout.findMany({
    where: {
      Program: {
        user_id: final_user_id,
      },
      NOT: {
        date_closed: null,
      },
      excercise_set_groups: {
        some: {
          excercise_name: {
            // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
            in: excercise_names_list!,
          },
        },
      },
    },
    include: {
      excercise_set_groups: {
        include: {
          excercise_sets: true,
        },
      },
    },
  });

  const one_rep_max_data_points = workouts.flatMap((workout) => {
    const exercise_set_groups_of_interest = workout.excercise_set_groups.filter(
      (esg) =>
        excercise_names_list.some(
          (exercise_name) => exercise_name == esg.excercise_name
        )
    );

    const data_points = exercise_set_groups_of_interest.map((esg) => {
      const estimated_one_rep_max_value = esg.excercise_sets.reduce(function (
        previousValue,
        currentSet
      ) {
        const current_set_est_value =
          (currentSet?.actual_weight ?? 0) *
          (1 + (currentSet.actual_reps ?? 0) / 30);
        const averaged_current_set_est_value =
          current_set_est_value / esg.excercise_sets.length;
        return previousValue + averaged_current_set_est_value;
      },
      0);

      return {
        exercise_name: esg.excercise_name,
        estimated_one_rep_max_value: estimated_one_rep_max_value,
        date_completed: workout.date_closed,
      };
    });

    return data_points;
  });
  return one_rep_max_data_points;
}

export async function analyticsExerciseTotalVolumeResolver(
  _: unknown,
  { excercise_names_list, user_id }: QueryAnalyticsExerciseTotalVolumeArgs,
  context: AppContext
) {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const final_user_id =
    user_id == undefined ? context.base_user!.User!.user_id : parseInt(user_id);

  // queries completed workouts that has at least 1 exercise set group that appear in the excercise_name_list
  const workouts = await prisma.workout.findMany({
    where: {
      Program: {
        user_id: final_user_id,
      },
      NOT: {
        date_closed: null,
      },
      excercise_set_groups: {
        some: {
          excercise_name: {
            in: excercise_names_list,
          },
        },
      },
    },
    include: {
      excercise_set_groups: {
        include: {
          excercise_sets: true,
        },
      },
    },
  });

  const exercise_total_volume_data_points = workouts.flatMap((workout) => {
    const exercise_set_groups_of_interest = workout.excercise_set_groups.filter(
      (esg) =>
        excercise_names_list.some(
          (exercise_name) => exercise_name == esg.excercise_name
        )
    );
    const data_points = exercise_set_groups_of_interest.map((esg) => {
      const exercise_total_volume = esg.excercise_sets.reduce(
        (previousValue, currentSet) =>
          previousValue +
          (currentSet.actual_weight ?? 0) * (currentSet.actual_reps ?? 0),
        0
      );

      return {
        exercise_name: esg.excercise_name,
        exercise_total_volume: exercise_total_volume,
        date_completed: workout.date_closed,
      };
    });

    return data_points;
  });
  return exercise_total_volume_data_points;
}

export async function analyticsWorkoutAverageRPEResolver(
  _: unknown,
  { user_id }: QueryAnalyticsExerciseTotalVolumeArgs,
  context: AppContext
) {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;

  const final_user_id =
    user_id == undefined ? context.base_user!.User!.user_id : parseInt(user_id);

  // queries completed workouts that has at least 1 exercise set group that appear in the excercise_name_list
  const workouts = await prisma.workout.findMany({
    where: {
      Program: {
        user_id: final_user_id,
      },
      NOT: {
        date_closed: null,
      },
    },
    include: {
      excercise_set_groups: {
        include: {
          excercise_sets: true,
        },
      },
    },
  });

  const average_rpe_value_data_points = workouts.flatMap((workout) => {
    const average_rpe_value =
      workout.excercise_set_groups.reduce(
        (previousValue, currentESG) =>
          previousValue +
          currentESG.excercise_sets.reduce(
            (previousSetValue, currentSet) =>
              previousSetValue + (currentSet.rate_of_perceived_exertion ?? 0),
            0
          ) /
            currentESG.excercise_sets.length,
        0
      ) / workout.excercise_set_groups.length;

    return {
      average_rpe_value: average_rpe_value,
      date_completed: workout.date_closed,
    };
  });
  return average_rpe_value_data_points;
}
