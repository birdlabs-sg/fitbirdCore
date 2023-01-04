import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { getActiveWorkout } from "../../../service/workout_manager/utils";
import { checkExistsAndOwnership } from "../../../service/workout_manager/utils";
import { AppContext } from "../../../types/contextType";
import { MutationDeleteWorkoutArgs } from "../../../types/graphql";

/**
 * deletes the workout specified by @workout_id
 * Note:
 * Returns the active workouts that belong to the same program as the deleted workout
 */
export const deleteWorkoutResolver = async (
  _: unknown,
  { workout_id }: MutationDeleteWorkoutArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  // Get the workout of interest
  await checkExistsAndOwnership({ context, workout_id });
  // delete the workout
  const deletedWorkout = await prisma.workout.delete({
    where: {
      workout_id: parseInt(workout_id),
    },
  });
  const { active_workouts } = await getActiveWorkout({
    context: context,
    program_id: JSON.stringify(deletedWorkout.programProgram_id),
  });

  return {
    code: "200",
    success: true,
    message: "Successfully deleted your workout!",
    workouts: active_workouts,
  };
};
