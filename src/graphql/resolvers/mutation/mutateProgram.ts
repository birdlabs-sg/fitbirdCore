import { AppContext } from "../../../types/contextType";
import { MutationCreateProgramArgs } from "../../../types/graphql";
import { getActiveProgram } from "../../../service/workout_manager/utils";
export const CreateProgram = async (
  _: any,
  { user_id, workouts }: MutationCreateProgramArgs,
  context: AppContext
) => {
  //at any given time, there will only be one active program for the user,so
  //1. change all existing programs to is_active = false
  //2. set the new program to be active,
  // onlyCoach(context);
  await prisma.program.update({
    where: {
      user_id: user_id,
      coach_id: context.coach.coach_id,
    },
    data: {
      is_active: false,
    },
  });

  await prisma.program.create({
    data: {
      user_id: user_id,
      coach_id: context.coach.coach_id,
      is_active: true,
      workouts: workouts,
    },
  });

  return {
    code: "200",
    success: true,
    message: "Successfully updated your workout!",
    program: await getActiveProgram(context, user_id),
  };
};
