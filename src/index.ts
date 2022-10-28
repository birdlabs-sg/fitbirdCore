import { resolvers } from "./graphql/resolvers/rootResolvers";
import { typeDefs } from "./graphql/typeDefs/rootTypeDefs";
import {
  authenticate,
  getAuthToken,
} from "./service/firebase/firebase_service";
import { ApolloServer } from "@apollo/server";
import { startStandaloneServer } from "@apollo/server/standalone";
import { ApolloServerPluginUsageReporting } from "@apollo/server/plugin/usageReporting";

import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

async function startApolloServer() {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const server = new ApolloServer<any>({
    typeDefs: typeDefs,
    resolvers: resolvers,
    csrfPrevention: true,
    introspection: true,
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
      return {
        token,
        ...(await authenticate(token)),
        dataSources: {
          prisma: prisma,
        },
      };
    },
    listen: { port: 8080 },
  });

  // eslint-disable-next-line no-console
  console.info(`🚀  Server ready at ${url}`);
}

startApolloServer();
