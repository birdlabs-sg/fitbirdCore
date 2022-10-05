import { Coach, PrismaClient, User } from "@prisma/client";
import { Context } from "vm";

export declare type AppContext = {
  authenticated: boolean;
  user: User;
  user_id: string;
  isAdmin: boolean;
  coach: Coach;
  dataSources: { prisma: PrismaClient };
} & Context;
