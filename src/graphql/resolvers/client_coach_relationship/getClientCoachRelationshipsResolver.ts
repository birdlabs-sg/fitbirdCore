import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { AppContext } from "../../../types/contextType";

/**
 * Retrieves client-coach relationships related to the requestor
 *
 */
export const getCoachClientRelationshipsResolver = async (
  _: unknown,
  __: unknown,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  return await prisma.coachClientRelationship.findMany({
    where: {
      ...(context.base_user?.coach?.coach_id && {
        coach_id: context.base_user?.coach?.coach_id,
      }),
      ...(context.base_user?.User?.user_id && {
        user_id: context.base_user?.User?.user_id,
      }),
    },
  });
};
