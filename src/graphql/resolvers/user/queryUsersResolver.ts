import { AppContext } from "../../../types/contextType";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { QueryUsersArgs } from "../../../types/graphql";
import { GraphQLError } from "graphql";

export const usersQueryResolver = async (
  _: unknown,
  { coach_filters }: QueryUsersArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  if (coach_filters && !context.base_user?.coach?.coach_id) {
    throw new GraphQLError("Requestor is not a coach.");
  }
  const prisma = context.dataSources.prisma;
  // reject non admins. Exception will be thrown if not
  return await prisma.user.findMany();
};
