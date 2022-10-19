import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { MutationUpdateUserArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";
import { getActiveWorkouts } from "../../../service/workout_manager/utils";
import { WorkoutType } from "@prisma/client";

export const updateUser = async (
  _: any,
  args: MutationUpdateUserArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  if (args.ai_managed_workouts_life_cycle) {
    // TODO: should have side effects on existing workouts
    const ai_managed_active_workouts = await getActiveWorkouts(
      context,
      WorkoutType.AI_MANAGED
    );
    var max_life_span = Math.max(
      ...ai_managed_active_workouts.map((workout) => workout.life_span)
    );
    if (args.ai_managed_workouts_life_cycle > max_life_span) {
      for (var ai_managed_workout of ai_managed_active_workouts) {
        await prisma.workout.update({
          where: {
            workout_id: ai_managed_workout.workout_id,
          },
          data: {
            life_span: args.ai_managed_workouts_life_cycle,
          },
        });
      }
    }
  }

  const updatedUser = await prisma.user.update({
    where: {
      user_id: context.user.user_id,
    },
    data: args,
  });

  return {
    code: "200",
    success: true,
    message: "Successfully updated your profile!",
    user: updatedUser,
  };
};
