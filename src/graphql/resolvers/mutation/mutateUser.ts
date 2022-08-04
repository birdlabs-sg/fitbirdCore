import { workoutGenerator } from "../../../service/workout_manager/workout_generator";
import { onlyAuthenticated } from "../../../service/firebase_service";

export const updateUser = async (_: any, args: any, context: any) => {
  onlyAuthenticated(context);
  const { generate_workouts, ...otherArgs } = args;
  const prisma = context.dataSources.prisma;
  const updatedUser = await prisma.user.update({
    where: {
      user_id: context.user.user_id,
    },
    data: otherArgs,
  });

  return {
    code: "200",
    success: true,
    message: "Successfully updated your profile!",
    user: updatedUser,
  };
};
