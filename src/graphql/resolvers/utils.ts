import { ProgramType } from "@prisma/client";
import { GraphQLError } from "graphql";
import { AppContext } from "../../types/contextType";
import { WorkoutState } from "@prisma/client";
/**
 *  Guards a resolver
 *
 */
export const clientCoachRelationshipGuard = async ({
  context,
  user_id,
  coach_id,
}: {
  context: AppContext;
  user_id: number;
  coach_id: number;
}) => {
  // Must match either user_id or coach_id
  const coachClientRelationship =
    await context.dataSources.prisma.coachClientRelationship.findUnique({
      where: {
        coach_id_user_id: {
          user_id: user_id,
          coach_id: coach_id,
        },
      },
    });
  if (!coachClientRelationship) {
    throw new GraphQLError("Coach client relationship does not exist.");
  }
};

/**
 *  Obtains the relevant stakeholders based on who the requestor is
 *
 */
export function getStakeHoldersID({
  context,
  user_id,
  coach_id,
}: {
  context: AppContext;
  user_id?: string;
  coach_id?: string;
}):
  | { user_id?: string; coach_id: string; requestor_type: "COACH" }
  | { user_id: string; coach_id?: string; requestor_type: "USER" } {
  if (context.base_user?.User?.user_id) {
    // normal user accessing
    return {
      user_id: context.base_user?.User?.user_id.toString(),
      coach_id: coach_id,
      requestor_type: "USER",
    };
  } else if (context.base_user?.coach?.coach_id) {
    // coach accessing
    return {
      user_id: user_id,
      coach_id: context.base_user?.coach?.coach_id.toString(),
      requestor_type: "COACH",
    };
  }
  throw new GraphQLError("Requestor does not have a valid id.");
}
export async function setAllProgramsInactive(
  context: AppContext,
  program_type: ProgramType
) {
  const prisma = context.dataSources.prisma;
  await prisma.program.updateMany({
    where: {
      program_type: program_type,
      is_active: true,
    },
    data: {
      is_active: false,
    },
  });
  const today = new Date();
  await prisma.workout.updateMany({
    where: {
      date_closed: null,
      Program: {
        program_type: program_type,
      },
    },
    data: {
      date_closed: today,
      workout_state: WorkoutState.CANCELLED,
    },
  });
}

// Get last date of current week in UTC
export function getLastDateOfCurrentWeek() {
  const now = new Date(new Date().toDateString());
  const day = now.getUTCDay();
  const diff = now.getUTCDate() - day + (day === 0 ? -6 : 6);
  const sunday = new Date(now.setUTCDate(diff));
  sunday.setHours(0, 0, 0, 0);
  return sunday;
}

export function getFirstDateOfCurrentWeek() {
  const now = new Date(new Date().toDateString());
  const day = now.getUTCDay();
  const diff = now.getUTCDate() - day;
  const monday = new Date(now.setUTCDate(diff));
  monday.setHours(0, 0, 0, 0);
  return monday;
}
