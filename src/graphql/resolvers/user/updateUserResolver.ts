import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { MutationUpdateUserArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";
import { checkProgramExistenceAndOwnership } from "../../../service/workout_manager/utils";
export const updateUser = async (
  _: unknown,
  { selected_exercise_for_analytics, ...args }: MutationUpdateUserArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  if (args.current_program_enrollment_id) {
    checkProgramExistenceAndOwnership({
      context: context,
      program_id: JSON.stringify(args.current_program_enrollment_id),
      user_id: JSON.stringify(context.base_user!.User!.user_id),
    });
  }
  const selected_exercises = await prisma.excercise.findMany({
    where: {
      excercise_name: {
        in: selected_exercise_for_analytics,
      },
    },
  });
  const updatedUser = await prisma.user.update({
    where: {
      user_id: context.base_user!.User!.user_id,
    },
    data: {
      ...(selected_exercise_for_analytics && {
        selected_exercise_for_analytics: {
          set: selected_exercises,
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
