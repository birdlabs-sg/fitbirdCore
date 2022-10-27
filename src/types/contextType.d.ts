<<<<<<< Updated upstream
import { PrismaClient, User } from "@prisma/client";
=======
import { BaseContext } from "@apollo/server";
import { BaseUser, Coach, PrismaClient, User } from "@prisma/client";
>>>>>>> Stashed changes

export declare type AppContext = {
  authenticated: boolean;
  base_user: BaseUser & {
    coach: Coach | null;
    User: User | null;
  };
  isAdmin: boolean;
  dataSources: { prisma: PrismaClient };
};
