"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getFirebaseIdToken = exports.onlyAdmin = exports.onlyAuthenticated = exports.authenticate = exports.getAuthToken = exports.signupFirebase = void 0;
const apollo_server_1 = require("apollo-server");
const admin = __importStar(require("firebase-admin"));
const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();
const dotenv = require("dotenv");
dotenv.config();
const axios = require("axios").default;
// Initializes the firebaseAuth service
const firebase = admin.initializeApp({
    credential: admin.credential.cert({
        privateKey: process.env.GOOGLE_SERVICE_ACCOUNT_PRIVATE_KEY.replace(/\\n/gm, "\n"),
        clientEmail: process.env.GOOGLE_SERVICE_ACCOUNT_CLIENT_EMAIL,
        projectId: process.env.GOOGLE_SERVICE_ACCOUNT_PROJECT_ID,
    }),
});
const signupFirebase = (email, phoneNumber, password, displayName) => __awaiter(void 0, void 0, void 0, function* () {
    // Done in backend so as to create an instance within our database as well.
    const firebaseUser = yield firebase.auth().createUser({
        email: email,
        emailVerified: false,
        phoneNumber: phoneNumber,
        password: password,
        displayName: displayName,
        disabled: false,
    });
    const prismaUser = yield prisma.user.create({
        data: {
            firebase_uid: firebaseUser.uid,
            email: firebaseUser.email,
            phoneNumber: firebaseUser.phoneNumber,
            displayName: firebaseUser.displayName,
        },
    });
    return prismaUser;
});
exports.signupFirebase = signupFirebase;
const getAuthToken = (req) => {
    if (req.headers.authorization) {
        return req.headers.authorization;
    }
    else {
        return null;
    }
};
exports.getAuthToken = getAuthToken;
const authenticate = (token) => __awaiter(void 0, void 0, void 0, function* () {
    if (!token) {
        return { authenticated: false, user: null, isAdmin: null };
    }
    try {
        const fireBaseUser = yield firebase.auth().verifyIdToken(token);
        const user = yield prisma.user.findUnique({
            where: {
                firebase_uid: fireBaseUser.uid,
            },
        });
        return { authenticated: true, user: user, isAdmin: !!fireBaseUser.admin };
    }
    catch (e) {
        console.log("HAVE TOKEN BUT FAILED TO AUTHENTICATE", e);
        return { authenticated: false, user: null, isAdmin: null };
    }
});
exports.authenticate = authenticate;
const onlyAuthenticated = (context) => {
    if (!context.authenticated) {
        throw new apollo_server_1.AuthenticationError("You are not authenticated.");
    }
};
exports.onlyAuthenticated = onlyAuthenticated;
const onlyAdmin = (context) => {
    if (!context.isAdmin) {
        throw new apollo_server_1.ForbiddenError("You are not authorized.");
    }
};
exports.onlyAdmin = onlyAdmin;
const getFirebaseIdToken = (uid) => __awaiter(void 0, void 0, void 0, function* () {
    const customToken = yield firebase.auth().createCustomToken(uid);
    const res = yield axios({
        url: `https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyCustomToken?key=${process.env.GOOGLE_API_KEY}`,
        method: "post",
        data: {
            token: customToken,
            returnSecureToken: true,
        },
        json: true,
    });
    return res.data;
});
exports.getFirebaseIdToken = getFirebaseIdToken;
//# sourceMappingURL=firebase_service.js.map