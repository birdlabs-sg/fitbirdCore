import { AppContext } from "../../../types/contextType";

import { QueryProgramsArgs } from "../../../types/graphql";
//find a specific program with the specified program_id
export const programsQueryResolver = async (
  _: unknown,
  args: QueryProgramsArgs,
  context: AppContext
) => {
  // enforce that the requestor must either be the coach or the user
  const { user_id, coach_id } = args;
  const prisma = context.dataSources.prisma;
  const program = await prisma.program.findFirstOrThrow({
    where: {
      ...(coach_id && { coach_id: parseInt(coach_id) }),
      user_id: parseInt(user_id),
      is_active: true,
    },
  });
  return program;
};
