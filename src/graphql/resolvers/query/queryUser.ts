import { onlyAuthenticated } from "../../../service/firebase_service";

export const userQueryResolvers = async (
  parent: any,
  args: any,
  context: any,
  info: any
) => {
  onlyAuthenticated(context);
  return context.user;
};
