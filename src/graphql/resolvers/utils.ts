import { GraphQLError } from "graphql";
import { AppContext } from "../../types/contextType";

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
  if (user_id == null && coach_id == null) {
    throw new GraphQLError("Must pass in at least one ID, coach_id or user_id");
  }
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

export function getLastDateOfCurrentWeek() {
  const now = new Date();
  const day = now.getDay();
  const diff = now.getDate() - day + (day === 0 ? -6 : 6);
  const sunday = new Date(now.setDate(diff));
  sunday.setHours(0, 0, 0, 0);
  return sunday;
}

export function getFirstDateOfCurrentWeek() {
  const now = new Date();
  const day = now.getDay();
  const diff = now.getDate() - day;
  const monday = new Date(now.setDate(diff));
  monday.setHours(0, 0, 0, 0);
  return monday;
}
