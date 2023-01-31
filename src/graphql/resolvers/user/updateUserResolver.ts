import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { MutationUpdateUserArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";
import { checkProgramExistenceAndOwnership } from "../../../service/workout_manager/utils";
export const updateUser = async (
  _: unknown,
  {
    selected_exercise_for_analytics,
    fcm_token,
    ...args
  }: MutationUpdateUserArgs,
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

  if (fcm_token) {
    for (const token of fcm_token) {
      const current_token = await prisma.fCMToken.findUnique({
        where: {
          token: token,
        },
      });
      if (current_token == null) {
        await prisma.fCMToken.create({
          data: {
            token: token!,
            baseUserBase_user_id: context.base_user!.base_user_id,
          },
        });
      } else {
        await prisma.fCMToken.update({
          where: {
            token: token,
          },
          data: {
            date_issued: new Date(Date.now()),
          },
        });
      }
    }
  }
  const selected_exercises = selected_exercise_for_analytics?.map(
    (excercise_name) => {
      return { excercise_name: excercise_name };
    }
  );

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
    user: updatedUser!,
  };
};
