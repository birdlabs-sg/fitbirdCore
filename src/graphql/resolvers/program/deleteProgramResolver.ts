import { MutationDeleteProgramArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";
import { clientCoachRelationshipGuard } from "./utils";

export const deleteprogramResolver = async (
  _: unknown,
  { program_id }: MutationDeleteProgramArgs,
  context: AppContext
) => {
  const prisma = context.dataSources.prisma;
  const { user_id, coach_id } = await prisma.program.findUniqueOrThrow({
    where: {
      program_id: parseInt(program_id),
    },
  });
  // if coach_id is null, will just perform check if user_id === requestor_id which is what we want.
  await clientCoachRelationshipGuard({
    context,
    user_id,
    coach_id,
    onlyAllowActiveRelationship: true,
    checkRelationship: true,
  });

  const program = await prisma.program.delete({
    where: {
      program_id: parseInt(program_id),
    },
  });
  return {
    code: "200",
    success: true,
    message: "Successfully deleted your program!",
    program: program,
  };
};
