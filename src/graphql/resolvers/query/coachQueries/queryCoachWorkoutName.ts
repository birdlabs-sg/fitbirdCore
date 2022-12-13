import { WorkoutState, WorkoutType } from "@prisma/client";
import { QueryCoachWorkoutNameArgs } from "../../../../types/graphql";
import { AppContext } from "../../../../types/contextType";
import { onlyCoach } from "../../../../service/firebase/firebase_service";
export async function coachWorkoutNameQueryResolver(
  _: unknown,
  { workout_name, user_id, programProgram_id }: QueryCoachWorkoutNameArgs,
  context: AppContext
) {
  onlyCoach(context);

  const prisma = context.dataSources.prisma;
  const result = await prisma.workout.findMany({
    where: {
      user_id: parseInt(user_id),
      workout_name: workout_name,
      workout_type: WorkoutType.COACH_MANAGED,
      workout_state: WorkoutState.COMPLETED,
      programProgram_id: parseInt(programProgram_id),
    },
    include: {
      excercise_set_groups: true,
    },

    orderBy: {
      date_completed: "desc",
    },
    take: 1,
  });
  return result[0]
}
