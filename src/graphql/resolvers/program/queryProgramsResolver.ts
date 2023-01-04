import { AppContext } from "../../../types/contextType";

import { QueryProgramsArgs } from "../../../types/graphql";
import { clientCoachRelationshipGuard } from "./utils";
//finds programs associated to the requestor.
export const queryProgramsResolver = async (
  _: unknown,
  { coach_id, user_id }: QueryProgramsArgs,
  context: AppContext
) => {
  // Enforces that the requestor has access to those programs
  await clientCoachRelationshipGuard({
    context,
    user_id: parseInt(user_id),
    coach_id: coach_id ? parseInt(coach_id) : null,
    onlyAllowActiveRelationship: true,
    checkRelationship: true,
  });
  const prisma = context.dataSources.prisma;
  const programs = await prisma.program.findMany({
    where: {
      ...(coach_id && { coach_id: parseInt(coach_id) }),
      user_id: parseInt(user_id),
      is_active: true,
    },
  });
  return programs;
};
