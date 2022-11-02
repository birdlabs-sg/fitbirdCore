import * as admin from "firebase-admin";
import { AppContext } from "../../types/contextType";
import { Context } from "vm";
import { GraphQLError } from "graphql";
import { Token } from "../../types/graphql";

import dotenv from "dotenv";
dotenv.config();
import axios from "axios";
import { PrismaClient } from "@prisma/client";

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
  is_user: boolean,
  context: AppContext
) => {
  const prisma = context.dataSources.prisma;
  // Done in backend so as to create an instance within our database as well. -> to do
  const firebaseUser = await firebase.auth().createUser({
    email: email,
    emailVerified: false,
    password: password,
    displayName: displayName,
    disabled: false,
  });

  if (is_user) {
    const prismaBaseUser = await prisma.baseUser.create({
      data: {
        firebase_uid: firebaseUser.uid,
        email: firebaseUser.email!,
        displayName: firebaseUser.displayName!,
        User: {
          create: {},
        },
      },
    });

    return prismaBaseUser;
  } else {
    const prismaBaseUser = await prisma.baseUser.create({
      data: {
        firebase_uid: firebaseUser.uid,
        email: firebaseUser.email!,
        displayName: firebaseUser.displayName!,
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

export const authenticate = async (token: string, prisma: PrismaClient) => {
  if (!token) {
    return { authenticated: false, base_user: null, isAdmin: null };
  }

  try {
    const fireBaseUser = await firebase.auth().verifyIdToken(token);
    const base_user = await prisma.baseUser.findUnique({
      where: {
        firebase_uid: fireBaseUser.uid,
      },
      include: {
        User: true,
        coach: true,
      },
    });

    return {
      authenticated: true,
      isAdmin: !!fireBaseUser.admin,
      base_user: base_user!,
    };
  } catch (e) {
    // eslint-disable-next-line no-console
    console.error("HAVE TOKEN BUT FAILED TO AUTHENTICATE", e);
    return { authenticated: false, base_user: null, isAdmin: null };
  }
};

export const onlyAuthenticated = (context: AppContext) => {
  if (!context.authenticated) {
    throw new GraphQLError("You are not authenticated.", {
      extensions: {
        code: "FORBIDDEN",
      },
    });
  }
};

export const onlyAdmin = (context: AppContext) => {
  if (!context.isAdmin) {
    throw new GraphQLError("You are not authorized.", {
      extensions: {
        code: "FORBIDDEN",
      },
    });
  }
};

export const onlyCoach = (context: AppContext) => {
  if (!context.base_user?.coach || !context.authenticated) {
    throw new GraphQLError("You are not authorized.", {
      extensions: {
        code: "FORBIDDEN",
      },
    });
    //context.coach = { coach_id: 2, base_user_id: 37 }
  }
};
export const isUser = (context: AppContext) => {
  if (context.base_user?.User) {
    return true;
  } else {
    return false;
  }
};

export async function getFirebaseIdToken(uid: string): Promise<Token> {
  const customToken = await firebase.auth().createCustomToken(uid);
  const res = await axios({
    method: "post",
    url: `https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyCustomToken?key=${process.env.GOOGLE_API_KEY}`,
    data: {
      token: customToken,
      returnSecureToken: true,
    },
  });
  return res.data;
}
