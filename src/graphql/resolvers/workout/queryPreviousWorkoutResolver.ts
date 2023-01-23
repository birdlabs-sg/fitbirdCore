import { AppContext } from "../../../types/contextType";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";

import { checkExistsAndOwnershipOnSharedResource } from "../program/deleteProgramResolver";
import { WorkoutState } from "@prisma/client";
import { QueryPreviousWorkoutArgs } from "../../../types/graphql";

export const queryPreviousWorkoutResolver = async (
  _: unknown,
  { workout_name, program_id }: QueryPreviousWorkoutArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  // Ensures that requestor matches one of them.
  console.log(workout_name);
  const programAffected = await prisma.program.findFirstOrThrow({
    where: {
      workouts: {
        some: {
          workout_name: workout_name,
          programProgram_id: parseInt(program_id),
        },
      },
    },
  });
  
  checkExistsAndOwnershipOnSharedResource({
    context: context,
    object: programAffected,
  });
  const workouts = await prisma.workout.findMany({
    where: {
      workout_name: workout_name,
      workout_state: WorkoutState.COMPLETED,
      date_closed: { not: null },
      programProgram_id: parseInt(program_id),
    },
    orderBy: [{ date_scheduled: "desc" }],
  });
console.log(workouts)
  return workouts[0];
};
