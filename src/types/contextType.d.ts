import { BaseContext } from "@apollo/server";
import { Coach, PrismaClient, User } from "@prisma/client";

interface AppContext {
  authenticated: boolean;
  user: User;
  user_id: string;
  isAdmin: boolean;
  coach: Coach;
  dataSources: { prisma: PrismaClient };
}
