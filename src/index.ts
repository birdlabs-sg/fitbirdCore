import { resolvers } from "./graphql/resolvers/rootResolvers";
import { typeDefs } from "./graphql/typeDefs/rootTypeDefs";
import {
  authenticate,
  getAuthToken,
} from "./service/firebase/firebase_service";
import { ApolloServer } from "apollo-server";
import { Context } from "vm";

const { PrismaClient } = require("@prisma/client");

const prisma = new PrismaClient();

<<<<<<< Updated upstream
const { logger } = require("./service/logging/logging_service");

const server = new ApolloServer({
  typeDefs: typeDefs,
  resolvers: resolvers,
  csrfPrevention: true,
  plugins: [logger],
  dataSources: () => {
    return {
      prisma: prisma,
    };
  },
  context: async ({ req }: Context) => {
    // Get the user token from the headers and put it into the coin.
    const token = getAuthToken(req);
    const authenticationInfo = await authenticate(token);
    return authenticationInfo;
  },
});

server.listen({ port: 8080 }).then(({ url }) => {
  console.log(`🚀 ${new Date().toISOString()}  Server ready at: ${url}`);
});
=======
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
      return {
        ...(await authenticate(token)),
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
>>>>>>> Stashed changes
