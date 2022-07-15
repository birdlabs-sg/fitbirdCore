import { signupFirebase } from "../../../service/firebase_service";

export const mutateSignup = async (
  _: any,
  { email, phoneNumber, password, displayName }: any
) => {
  const user = await signupFirebase(email, phoneNumber, password, displayName);
  return {
    code: "200",
    success: true,
    message: "Successfully created an account! Welcome onboard.",
    user: user,
  };
};
