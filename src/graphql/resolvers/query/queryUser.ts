import { AppContext } from "../../../types/contextType";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";

export const userQueryResolvers = async (
  _: any,
  __: any,
  context: AppContext
) => {
  onlyAuthenticated(context);
  return context.base_user!.User;
};
