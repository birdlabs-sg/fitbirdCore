import { MutationUpdateProgramArgs } from "../../../types/graphql";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { AppContext } from "../../../types/contextType";
import { clientCoachRelationshipGuard } from "./utils";
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
  const { user_id, coach_id } = await prisma.program.findUniqueOrThrow({
    where: {
      program_id: parseInt(program_id),
    },
  });
  // requestor must match either user_id OR coach_id
  await clientCoachRelationshipGuard({
    context,
    user_id,
    coach_id,
    checkRelationship: true,
    onlyAllowActiveRelationship: true,
  });

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
