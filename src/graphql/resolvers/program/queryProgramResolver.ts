import { AppContext } from "../../../types/contextType";
import { QueryProgramArgs } from "../../../types/graphql";
import { Program, WorkoutState } from "@prisma/client";
import { checkExistsAndOwnershipOnSharedResource } from "./deleteProgramResolver";
import { Workout } from "@prisma/client";
import { GraphQLError } from "graphql";
//TODO: implement view mode
//finds programs associated to the requestor.
export const queryProgramResolver = async (
  _: unknown,
  { program_id, filter }: QueryProgramArgs,
  context: AppContext
) => {
  // Enforces that the requestor has access to those programs
  const prisma = context.dataSources.prisma;
  // if a filter exists then we do not query by program_id
  if (!program_id && !filter) {
    throw new GraphQLError("please provide either program_id or filter.");
  }
  if (filter) {
    const programToQuery = await prisma.program.findFirstOrThrow({
      where: {
        ...(filter.is_active && {
          is_active: filter.is_active,
        }),
        ...(filter.user_id && {
          user_id: parseInt(filter.user_id),
        }),
      },
      include: { workouts: true },
    });

    if (!filter.overview_mode) {
      return programToQuery;
    }

    let newWorkouts: Workout[] = [];
    let i = 0;
    let counter = 7;
    while (i < programToQuery.workouts.length && counter > 0) {
      if (
        parseInt(programToQuery.workouts[i].workout_name.slice(-1)) === counter
      ) {
        newWorkouts.push(programToQuery.workouts[i]);
        i++;
        counter--;
      } else {
        let restDay: Workout = {
          workout_id: 0,
          workout_name: `Day ${counter}`,
          date_scheduled: new Date(),
          date_closed: null,
          last_completed: null,
          performance_rating: null,
          workout_state: WorkoutState.UNATTEMPTED,
          programProgram_id: 0,
        };
        newWorkouts.push(restDay);
        counter--;
      }
    }
    
    let newProg: Program & {
      workouts: Workout[];
    } = {
      program_type: programToQuery.program_type,
      program_id: programToQuery.program_id,
      coach_id: programToQuery.coach_id,
      user_id: programToQuery.user_id,
      is_active: programToQuery.is_active,
      starting_date: programToQuery.starting_date,
      ending_date: programToQuery.ending_date,
      workouts: newWorkouts,
    };

    return newProg;

  } 
  
  else {
    const programToQuery = await prisma.program.findFirstOrThrow({
      where: {
        program_id: parseInt(program_id!),
      },
    });
    checkExistsAndOwnershipOnSharedResource({
      context: context,
      object: programToQuery,
    });
    return programToQuery;
  }

  
};
