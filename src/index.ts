import { resolvers } from "./graphql/resolvers/rootResolvers";
import { typeDefs } from "./graphql/typeDefs/rootTypeDefs";
import {
  authenticate,
  getAuthToken,
} from "./service/firebase/firebase_service";
import { ApolloServer } from "@apollo/server";
import { startStandaloneServer } from "@apollo/server/standalone";
import { ApolloServerPluginUsageReporting } from "@apollo/server/plugin/usageReporting";

const { PrismaClient } = require("@prisma/client");

const prisma = new PrismaClient();

const { logger } = require("./service/logging/logging_service");

async function startApolloServer() {
  const server = new ApolloServer<any>({
    typeDefs: typeDefs,
    resolvers: resolvers,
    csrfPrevention: true,
    plugins: [
      ApolloServerPluginUsageReporting({
        // If you pass unmodified: true to the usage reporting
        // plugin, Apollo Studio receives ALL error details
        sendErrors: { unmodified: true },
      }),
    ],
  });

  const { url } = await startStandaloneServer(server, {
    context: async ({ req }) => {
      const token = getAuthToken(req);
      const { authenticated, user, isAdmin, coach } = await authenticate(token);
      return {
        token,
        authenticated,
        user,
        isAdmin,
        coach,
        dataSources: {
          prisma: prisma,
        },
      };
    },
    listen: { port: 8080 },
  });

  console.log(`🚀  Server ready at ${url}`);
}

startApolloServer();
