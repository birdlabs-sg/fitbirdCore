import { MutationSignupArgs } from "../../../types/graphql";
import { signupFirebase } from "../../../service/firebase/firebase_service";
import { AppContext } from "../../../types/contextType";

export const mutateSignup = async (
  _: unknown,
  { email, password, displayName, is_user }: MutationSignupArgs,
  context: AppContext
) => {
  const user = await signupFirebase(
    email,
    password,
    displayName,
    is_user,
    context
  );
  return {
    code: "200",
    success: true,
    message: "Successfully created an account! Welcome onboard.",
    user: user,
  };
};
