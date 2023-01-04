import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { MutationUpdateUserArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";
import { checkProgramExistenceAndOwnership } from "../../../service/workout_manager/utils";
export const updateUser = async (
  _: unknown,
  {
    selected_exercise_for_analytics,
    current_program_enrollment_id,
    ...args
  }: MutationUpdateUserArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  if (current_program_enrollment_id) {
    checkProgramExistenceAndOwnership({
      context: context,
      program_id: JSON.stringify(current_program_enrollment_id),
      user_id: JSON.stringify(context.base_user!.User!.user_id),
    });
  }
  const updatedUser = await prisma.user.update({
    where: {
      user_id: context.base_user!.User!.user_id,
    },
    data: {
      ...(selected_exercise_for_analytics && {
        selected_exercise_for_analytics: {
          set: selected_exercise_for_analytics,
        },
      }),
      ...args,
    },
  });

  return {
    code: "200",
    success: true,
    message: "Successfully updated your profile!",
    user: updatedUser,
  };
};
