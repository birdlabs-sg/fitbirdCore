import { AppContext } from "../../../types/contextType";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { QueryWorkoutArgs } from "../../../types/graphql";
import { checkExistsAndOwnershipOnSharedResource } from "../program/deleteProgramResolver";

export const queryWorkoutResolver = async (
  _: unknown,
  { workout_id }: QueryWorkoutArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;

  // Ensures that requestor matches one of them.
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
  
  return await prisma.workout.findUniqueOrThrow({
    where: {
      // remove this to access other programs not associated with this coach
      workout_id: parseInt(workout_id),
    },
  });
};
