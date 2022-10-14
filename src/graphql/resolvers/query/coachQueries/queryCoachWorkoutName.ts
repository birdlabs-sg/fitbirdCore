import { WorkoutState, WorkoutType } from "@prisma/client";
import {
  QueryCoachWorkoutNameArgs,
  } from "../../../../types/graphql";
  import { AppContext } from "../../../../types/contextType";
  import {
    onlyAuthenticated,
    onlyCoach,
  } from "../../../../service/firebase/firebase_service";
export async function coachWorkoutNameQueryResolver(
    _: any,
    {workout_name,user_id}:QueryCoachWorkoutNameArgs,
    context: AppContext
  ) {
    onlyCoach(context);
  
    const prisma = context.dataSources.prisma;
  
        return await prisma.workout.findFirst({
          where: {
            user_id:parseInt(user_id),
            workout_name:workout_name,
            workout_type: WorkoutType.COACH_MANAGED,
            workout_state:WorkoutState.COMPLETED
          },
          include:{
            excercise_set_groups:true
          }
        });
  
  }
  