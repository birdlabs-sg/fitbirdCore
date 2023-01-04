// import { QueryWorkoutArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { QueryWorkoutArgs } from "../../../types/graphql";
import { clientCoachRelationshipGuard } from "../program/utils";
import { checkExistsAndOwnership } from "../../../service/workout_manager/utils";

export const queryWorkoutResolver = async (
  _: unknown,
  { workout_id, user_id, coach_id }: QueryWorkoutArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  // Ensures that requestor matches one of them.
  await clientCoachRelationshipGuard({
    context,
    user_id: parseInt(user_id),
    coach_id: coach_id ? parseInt(coach_id) : null,
    onlyAllowActiveRelationship: false,
    checkRelationship: false,
  });

  await checkExistsAndOwnership({
    context,
    workout_id,
    user_id,
  });

  return await prisma.workout.findUniqueOrThrow({
    where: {
      // remove this to access other programs not associated with this coach
      ...(coach_id && {
        Program: {
          coach_id: parseInt(coach_id),
        },
      }),
      workout_id: parseInt(workout_id),
    },
  });
};
