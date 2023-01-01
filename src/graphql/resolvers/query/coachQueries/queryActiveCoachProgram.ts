import { AppContext } from "../../../../types/contextType";

import { onlyCoach } from "../../../../service/firebase/firebase_service";
import { QueryCoachActiveProgramArgs } from "../../../../types/graphql";
import { Program, Workout, WorkoutState, WorkoutType } from "@prisma/client";
//find a specific program with the specified program_id
export const coachActiveProgramQueryResolver = async (
  _: any,
  args: QueryCoachActiveProgramArgs,
  context: AppContext
) => {
  onlyCoach(context);
  const { user_id } = args;
  const prisma = context.dataSources.prisma;
  const program = await prisma.program.findFirst({
    where: {
      coach_id: context.base_user!.coach!.coach_id,
      user_id: parseInt(user_id),
      is_active: true,
    },
    include: {
      workouts: true,
    },
  });
  ///------------------ Temp workaround segment (To be tested once app is completed) -----------------------------///
  /* The issue was that this endpoint is supposed to return only information of workouts up to 7 days, including rest days, in a week, to showcase the flow of the program.
    However, there is no way to distinguish between each completed workouts and each rest days, as these features have not beem implemented on the schema, and the number of completed workouts may exceed 7 OR the number of workouts per week is less than 7, and this would result in skipping some days, which is not the desired outcome for this endpoint
    A workout program can therefore only be identified in its index via the last 5 letters of its workout name , eg:" abc - Day 1", therefore, we can use it to identify which day it belongs in the workout list of 7 days via this workaround using placeholder workouts:
    1. The counter checks the number of times that it has looped through, a total of 7 days is required to return 1 week of workouts
    2. The i value checks if it is still possible to retrieve the workout from the list of workouts, if it cannot, then it means that it has already reached the end of the program list (may be until a day that is before day 7, hence the other contition, (1) is still required)
    *** However, this assumes that the workouts created by are ordered in decending order: Day 7,6,5,4,3,2,1
    */

  let newWorkouts: Workout[] = [];
  let i = 0;
  let counter = 7;
  while (i < program.workouts.length && counter>0) {
    if (parseInt(program.workouts[i].workout_name.slice(-1)) === counter) {
      newWorkouts.push(program.workouts[i]);
      i++;
      counter --;
    } else {
      let restDay: Workout = {
        workout_id: 0,
        workout_name: `Day ${counter}`,
        life_span: 0,
        order_index: 0,
        date_scheduled: null,
        date_completed: null,
        performance_rating: null,
        user_id: parseInt(user_id),
        workout_state: WorkoutState.UNATTEMPTED,
        workout_type: WorkoutType.COACH_MANAGED,
        programProgram_id: 0,
      };
      newWorkouts.push(restDay);
      counter--;
    }
  }

  let newProg: Program & {
    workouts: Workout[];
  } = {
    program_id: program.program_id,
    coach_id: program.coach_id,
    user_id: program.user_id,
    is_active: program.is_active,
    workouts: newWorkouts,
  };

///------------------ Temp workaround segment (to be tested once app is completed) -----------------------------///
  return newProg;
};
