import { BaseUser, Coach, PrismaClient, User } from '@prisma/client';

interface AppContext {
  authenticated: boolean;
  base_user?: BaseUser & {
    coach: Coach | null;
    User: User | null;
  };
  isAdmin: boolean;
  dataSources: { prisma: PrismaClient };
}
