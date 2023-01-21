import { AppContext } from "../../../types/contextType";
import { QueryProgramArgs } from "../../../types/graphql";
import { checkExistsAndOwnershipOnSharedResource } from "./deleteProgramResolver";

//finds programs associated to the requestor.
export const queryProgramResolver = async (
  _: unknown,
  { program_id }: QueryProgramArgs,
  context: AppContext
) => {
  // Enforces that the requestor has access to those programs
  const prisma = context.dataSources.prisma;
  const programToQuery = await prisma.program.findFirstOrThrow({
    where: {
      program_id: parseInt(program_id),
    },
  });
  checkExistsAndOwnershipOnSharedResource({
    context: context,
    object: programToQuery,
  });
  return programToQuery;
};
