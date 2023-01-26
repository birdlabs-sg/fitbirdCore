import { GraphQLError } from "graphql";
import { AppContext } from "../../../types/contextType";

import { QueryProgramsArgs } from "../../../types/graphql";
import { clientCoachRelationshipGuard, getStakeHoldersID } from "../utils";
//finds programs associated to the requestor.
export const queryProgramsResolver = async (
  _: unknown,
  { coach_id, user_id }: QueryProgramsArgs,
  context: AppContext
) => {
  const stakeholderIds = getStakeHoldersID({
    context: context,
    user_id: user_id,
    coach_id: coach_id,
  });
  if (stakeholderIds.user_id == null) {
    throw new GraphQLError(
      "user_id is required, however we were unable to infer it."
    );
  }
  if (stakeholderIds.requestor_type == "COACH") {
    // Enforces that the requestor has access to those programs
    await clientCoachRelationshipGuard({
      context,
      user_id: parseInt(stakeholderIds.user_id),
      coach_id: parseInt(stakeholderIds.coach_id),
    });
  }
  const prisma = context.dataSources.prisma;
  const programs = await prisma.program.findMany({
    where: {
      ...(stakeholderIds.coach_id && {
        coach_id: parseInt(stakeholderIds.coach_id),
      }),
      user_id: parseInt(stakeholderIds.user_id),
      // TODO add filter for this
      // is_active: true,
    },
  });
  return programs;
};
