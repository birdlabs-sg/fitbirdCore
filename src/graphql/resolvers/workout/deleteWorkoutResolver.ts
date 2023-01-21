import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { AppContext } from "../../../types/contextType";
import { MutationDeleteWorkoutArgs } from "../../../types/graphql";
import { checkExistsAndOwnershipOnSharedResource } from "../program/deleteProgramResolver";

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
  const programAffected = await prisma.program.findFirstOrThrow({
    where: {
      workouts: {
        some: {
          workout_id: parseInt(workout_id),
        },
      },
    },
  });
  checkExistsAndOwnershipOnSharedResource({
    context: context,
    object: programAffected,
  });
  // delete the workout
  const deletedWorkout = await prisma.workout.delete({
    where: {
      workout_id: parseInt(workout_id),
    },
  });
  return {
    code: "200",
    success: true,
    message: "Successfully deleted your workout!",
    workout: deletedWorkout,
  };
};
