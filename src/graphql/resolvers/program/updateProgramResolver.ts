import { MutationUpdateProgramArgs } from "../../../types/graphql";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { AppContext } from "../../../types/contextType";
import { clientCoachRelationshipGuard } from "../utils";
import { checkExistsAndOwnershipOnSharedResource } from "./deleteProgramResolver";
/**
 * Updates the program specified by @program_id
 */
export const updateProgramResolver = async (
  _: unknown,
  {
    program_id,
    coach_id: new_coach_id,
    ...otherArgs
  }: MutationUpdateProgramArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);

  const prisma = context.dataSources.prisma;
  const programToUpdate = await prisma.program.findUniqueOrThrow({
    where: {
      program_id: parseInt(program_id),
    },
  });
  checkExistsAndOwnershipOnSharedResource({
    context: context,
    object: programToUpdate,
  });
  if (new_coach_id != null) {
    // Enforce that there's already a relationship.
    await clientCoachRelationshipGuard({
      context,
      user_id: programToUpdate.user_id,
      coach_id: parseInt(new_coach_id),
    });
  }
  const updatedProgram = await prisma.program.update({
    where: {
      program_id: parseInt(program_id),
    },
    data: {
      ...(new_coach_id && { coach_id: parseInt(new_coach_id) }),
      ...otherArgs,
    },
  });
  return {
    code: "200",
    success: true,
    message: "Successfully updated your program!",
    program: updatedProgram,
  };
};
