import { onlyAuthenticated } from "../../../service/firebase/firebase_service";

export const userQueryResolvers = async (_: any, __: any, context: any) => {
  onlyAuthenticated(context);
  return context.user;
};
