import { WorkoutType } from "@prisma/client";
import { AppContext } from "../../../types/contextType";
import { InputMaybe } from "../../../types/graphql";

/**
 * Reorders the current active set of workouts (AKA current rotation) based on the @oldIndex and @newIndex provided
 * Note:
 * 1. If either @oldindex or no @newIndex is missing, it will just reorder them based on order_index ascending order
 * 2. Reason for this is to reorder the rest because the order was broken (completion, deletion, etc)
 * 3. ONLY reorders the @workout_type active workouts
 */
export async function reorderActiveWorkouts(
  context: AppContext,
  oldIndex: InputMaybe<number>,
  newIndex: InputMaybe<number>,
  workout_type: WorkoutType
) {
  const prisma = context.dataSources.prisma;
  // get all active workouts by their order_index
  const active_workouts = await prisma.workout.findMany({
    where: {
      date_completed: null,
      user_id: context.base_user.User!.user_id,
      workout_type: workout_type,
    },
    orderBy: {
      order_index: "asc",
    },
  });

  if (oldIndex != undefined && newIndex != undefined) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    const workout = active_workouts.splice(oldIndex, 1)[0];
    active_workouts.splice(newIndex, 0, workout);
  }
  for (var i = 0; i < active_workouts.length; i++) {
    const { workout_id } = active_workouts[i];
    await prisma.workout.update({
      where: {
        workout_id: workout_id,
      },
      data: {
        order_index: i,
      },
    });
  }
}
