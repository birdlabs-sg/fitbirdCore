import { MutationGenerateFirebaseIdTokenArgs } from "../../../types/graphql";
import { getFirebaseIdToken } from "../../../service/firebase/firebase_service";

export const generateFirebaseIdTokenResolver = async (
  _: any,
  { uid }: MutationGenerateFirebaseIdTokenArgs
) => {
  const token = await getFirebaseIdToken(uid);
  return {
    code: "200",
    success: true,
    message:
      "Successfully generated Firebase Id token. Store this somewhere safe.",
    token: token,
  };
};
