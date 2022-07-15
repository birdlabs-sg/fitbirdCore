import { getFirebaseIdToken } from "../../../service/firebase_service";

export const generateFirebaseIdTokenResolver = async (_: any, { uid }: any) => {
  const token = await getFirebaseIdToken(uid);
  return {
    code: "200",
    success: true,
    message:
      "Successfully generated Firebase Id token. Store this somewhere safe.",
    token: token,
  };
};
