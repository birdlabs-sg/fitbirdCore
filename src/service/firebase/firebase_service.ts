import { AuthenticationError, ForbiddenError } from "apollo-server";
import * as admin from "firebase-admin";
import { AppContext } from "../../types/contextType";
import { Context } from "vm";

const { PrismaClient } = require("@prisma/client");

const prisma = new PrismaClient();
const dotenv = require("dotenv");
dotenv.config();
const axios = require("axios").default;

// Initializes the firebaseAuth service
const firebase = admin.initializeApp({
  credential: admin.credential.cert({
    privateKey: process.env.GOOGLE_SERVICE_ACCOUNT_PRIVATE_KEY!.replace(
      /\\n/gm,
      "\n"
    ),
    clientEmail: process.env.GOOGLE_SERVICE_ACCOUNT_CLIENT_EMAIL,
    projectId: process.env.GOOGLE_SERVICE_ACCOUNT_PROJECT_ID,
  }),
});

export const signupFirebase = async (
  email: string,
  password: string,
  displayName: string,
  is_user: boolean
) => {
  // Done in backend so as to create an instance within our database as well. -> to do
  const firebaseUser = await firebase.auth().createUser({
    email: email,
    emailVerified: false,
    password: password,
    displayName: displayName,
    disabled: false,
  });

  if (is_user) {
    const prismaBaseUser = await prisma.BaseUser.create({
      data: {
        firebase_uid: firebaseUser.uid,
        email: firebaseUser.email,
        displayName: firebaseUser.displayName,
        User: {
          create: {},
        },
      },
    });

    return prismaBaseUser;
  } else {
    const prismaBaseUser = await prisma.BaseUser.create({
      data: {
        firebase_uid: firebaseUser.uid,
        email: firebaseUser.email,
        displayName: firebaseUser.displayName,
        coach: {
          create: {},
        },
      },
    });

    return prismaBaseUser;
  }
};

export const getAuthToken = (req: Context) => {
  if (req.headers.authorization) {
    return req.headers.authorization;
  } else {
    return null;
  }
};

export const authenticate = async (token: string) => {
  if (!token) {
    return { authenticated: false, user: null, isAdmin: null };
  }
  try {
    const fireBaseUser = await firebase.auth().verifyIdToken(token);
    const base_user = await prisma.BaseUser.findUnique({
      where: {
        firebase_uid: fireBaseUser.uid,
      },
      include: {
        User: true,
        coach: true,
      },
    });

    // if the user is not a coach
    if (base_user.coach == null) {
      return {
        authenticated: true,
        user: base_user.user,
        isAdmin: !!fireBaseUser.admin,
        coach: null,
      };
    }
    // if the user is a coach
    else {
      return {
        authenticated: true,
        user: null,
        isAdmin: !!fireBaseUser.admin,
        coach: base_user.coach,
      };
    }
    
  } catch (e) {
    console.log("HAVE TOKEN BUT FAILED TO AUTHENTICATE", e);
    return { authenticated: false, user: null, isAdmin: null, coach: null };
  }
};

export const onlyAuthenticated = (context: AppContext) => {
  if (!context.authenticated) {
   throw new AuthenticationError("You are not authenticated.");
  }
};

export const onlyAdmin = (context: AppContext) => {
  if (!context.isAdmin) {
    throw new ForbiddenError("You are not authorized.");
    
  }
};

export const onlyCoach = (context: AppContext) => {
  if (!context.coach) {
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
