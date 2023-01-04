import { QueryWorkoutsArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { clientCoachRelationshipGuard } from "../program/utils";
export async function queryWorkoutsResolver(
  _: unknown,
  { filter }: QueryWorkoutsArgs,
  context: AppContext
) {
  const { completed, workout_name, program_id, user_id, coach_id } = filter;

  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  await clientCoachRelationshipGuard({
    context,
    user_id: parseInt(user_id),
    coach_id: coach_id ? parseInt(coach_id) : null,
    onlyAllowActiveRelationship: true,
    checkRelationship: false,
  });

  return await prisma.workout.findMany({
    where: {
      Program: {
        user_id: parseInt(user_id),
        // remove this to access other programs not associated with this coach
        ...(coach_id && {
          coach_id: parseInt(coach_id),
        }),
      },
      ...(completed != undefined && {
        date_closed: completed ? { not: null } : null,
      }),
      ...(workout_name && {
        workout_name: workout_name,
      }),
      ...(program_id && {
        program_id: program_id,
      }),
    },
  });
}
