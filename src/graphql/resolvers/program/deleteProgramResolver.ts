import { MutationDeleteProgramArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";
import { GraphQLError } from "graphql";

export const deleteprogramResolver = async (
  _: unknown,
  { program_id }: MutationDeleteProgramArgs,
  context: AppContext
) => {
  const prisma = context.dataSources.prisma;
  const programToDelete = await prisma.program.findUniqueOrThrow({
    where: {
      program_id: parseInt(program_id),
    },
  });
  checkExistsAndOwnershipOnSharedResource({
    context: context,
    object: programToDelete,
  });
  const program = await prisma.program.delete({
    where: {
      program_id: programToDelete.program_id,
    },
  });
  return {
    code: "200",
    success: true,
    message: "Successfully deleted your program!",
    program: program,
  };
};

interface sharedResource {
  user_id: number;
  coach_id: number | null;
}
export function checkExistsAndOwnershipOnSharedResource({
  context,
  object,
}: {
  context: AppContext;
  object: sharedResource;
}) {
  const requestor_id =
    context.base_user?.User?.user_id ?? context.base_user?.coach?.coach_id;
  if (requestor_id == null) throw new GraphQLError("Not authenticated.");

  if (object.coach_id != requestor_id && object.user_id != requestor_id)
    throw new GraphQLError("User does not own the object.");
}
