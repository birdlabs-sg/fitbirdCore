import { PrismaClient, User } from "@prisma/client";

export declare type AppContext = {
  authenticated: boolean;
  user: User;
  user_id: string;
  isAdmin: boolean;
  dataSources: { prisma: PrismaClient };
};
