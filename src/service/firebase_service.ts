import { AuthenticationError, ForbiddenError } from "apollo-server";
import * as admin from "firebase-admin";

const { PrismaClient } = require("@prisma/client");

const prisma = new PrismaClient();
const dotenv = require("dotenv");
dotenv.config();
const axios = require("axios").default;

// Initializes the firebaseAuth service
const firebase = admin.initializeApp({
  credential: admin.credential.cert({
    privateKey: process.env.GOOGLE_SERVICE_ACCOUNT_PRIVATE_KEY.replace(
      /\\n/gm,
      "\n"
    ),
    clientEmail: process.env.GOOGLE_SERVICE_ACCOUNT_CLIENT_EMAIL,
    projectId: process.env.GOOGLE_SERVICE_ACCOUNT_PROJECT_ID,
  }),
});

export const signupFirebase = async (
  email: any,
  phoneNumber: any,
  password: any,
  displayName: any
) => {
  // Done in backend so as to create an instance within our database as well.
  const firebaseUser = await firebase.auth().createUser({
    email: email,
    emailVerified: false,
    phoneNumber: phoneNumber,
    password: password,
    displayName: displayName,
    disabled: false,
  });
  const prismaUser = await prisma.user.create({
    data: {
      firebase_uid: firebaseUser.uid,
      email: firebaseUser.email,
      phoneNumber: firebaseUser.phoneNumber,
      displayName: firebaseUser.displayName,
    },
  });
  return prismaUser;
};

export const getAuthToken = (req: any) => {
  if (req.headers.authorization) {
    return req.headers.authorization;
  } else {
    return null;
  }
};

export const authenticate = async (token: any) => {
  if (!token) {
    return { authenticated: false, user: null, isAdmin: null };
  }
  try {
    const fireBaseUser = await firebase.auth().verifyIdToken(token);
    const user = await prisma.user.findUnique({
      where: {
        firebase_uid: fireBaseUser.uid,
      },
    });
    return { authenticated: true, user: user, isAdmin: !!fireBaseUser.admin };
  } catch (e) {
    console.log(e);
    console.log("HAVE TOKEN BUT FAILED TO AUTHENTICATE@");
    return { authenticated: false, user: null, isAdmin: null };
  }
};

export const onlyAuthenticated = (context: any) => {
  if (!context.authenticated) {
    throw new AuthenticationError("You are not authenticated.");
  }
};

export const onlyAdmin = (context: any) => {
  if (!context.isAdmin) {
    throw new ForbiddenError("You are not authorized.");
  }
};

export const getFirebaseIdToken = async (uid: string) => {
  const customToken = await firebase.auth().createCustomToken(uid);
  const res = await axios({
    url: `https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyCustomToken?key=${process.env.GOOGLE_API_KEY}`,
    method: "post",
    data: {
      token: customToken,
      returnSecureToken: true,
    },
    json: true,
  });
  return res.data;
};
