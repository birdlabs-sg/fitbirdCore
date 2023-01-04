import { AppContext } from "../../../types/contextType";

import { QueryProgramArgs } from "../../../types/graphql";
import { clientCoachRelationshipGuard } from "./utils";
//finds programs associated to the requestor.
export const queryProgramResolver = async (
  _: unknown,
  { program_id, coach_id, user_id }: QueryProgramArgs,
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
  const program = await prisma.program.findFirstOrThrow({
    where: {
      program_id: parseInt(program_id),
      user_id: parseInt(user_id),
      ...(coach_id && { coach_id: parseInt(coach_id) }),
    },
  });
  return program;
};
