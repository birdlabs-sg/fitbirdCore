import { Coach, PrismaClient, User } from "@prisma/client";

export declare type AppContext = {
  authenticated: boolean;
  user: User;
  user_id: string;
  isAdmin: boolean;
  coach: Coach;
  dataSources: { prisma: PrismaClient };
};
