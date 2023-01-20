import { AppContext } from "../../../types/contextType";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { GraphQLError } from "graphql";

export const userQueryResolver = async (
  _: unknown,
  __: unknown,
  context: AppContext
) => {
  onlyAuthenticated(context);
  if (context.base_user?.User == null) {
    throw new GraphQLError("This endpoint is for Users only.");
  }
  return context.base_user!.User!;
};
