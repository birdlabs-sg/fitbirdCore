import { QueryWorkoutsArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { clientCoachRelationshipGuard, getStakeHoldersID } from "../utils";
import { GraphQLError } from "graphql";

export async function queryWorkoutsResolver(
  _: unknown,
  { user_id, filter }: QueryWorkoutsArgs,
  context: AppContext
) {
  const { completed, workout_name, program_id, program_type } = filter;
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const stakeholderIds = getStakeHoldersID({
    context: context,
    user_id: user_id,
    coach_id: undefined,
  });
  if (stakeholderIds.user_id == null) {
    throw new GraphQLError(
      "user_id is required, however we were unable to infer it."
    );
  }
  if (stakeholderIds.requestor_type == "COACH") {
    await clientCoachRelationshipGuard({
      context,
      user_id: parseInt(stakeholderIds.user_id),
      coach_id: parseInt(stakeholderIds.coach_id),
    });
  }

  return await prisma.workout.findMany({
    where: {
      Program: {
        user_id: parseInt(stakeholderIds.user_id),

        ...(stakeholderIds.coach_id && {
          coach_id: parseInt(stakeholderIds.coach_id),
        }),
        ...(program_type && {
          program_type: program_type,
        }),
      },
      ...(completed != undefined && {
        date_closed: completed ? { not: null } : null,
      }),
      ...(workout_name && {
        workout_name: workout_name,
      }),
      ...(program_id && {
        programProgram_id: parseInt(program_id),
      }),
    },
    orderBy: {
      date_closed: "desc",
    },
  });
}
