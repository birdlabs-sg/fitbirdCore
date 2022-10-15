import { MutationSignupArgs } from "../../../types/graphql";
import { signupFirebase } from "../../../service/firebase/firebase_service";

export const mutateSignup = async (
  _: any,
  { email, password, displayName, is_user }: MutationSignupArgs
) => {
  const user = await signupFirebase(email, password, displayName, is_user);
  return {
    code: "200",
    success: true,
    message: "Successfully created an account! Welcome onboard.",
    user: user,
  };
};
