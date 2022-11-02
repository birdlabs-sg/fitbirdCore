import { resolvers } from "./graphql/resolvers/rootResolvers";
import { typeDefs } from "./graphql/typeDefs/rootTypeDefs";
import {
  authenticate,
  getAuthToken,
} from "./service/firebase/firebase_service";
import { ApolloServer, ApolloServerPlugin } from "@apollo/server";
import { startStandaloneServer } from "@apollo/server/standalone";
import { ApolloServerPluginUsageReporting } from "@apollo/server/plugin/usageReporting";

import { PrismaClient } from "@prisma/client";
import { report } from "./service/slack/slack_service";

const prisma = new PrismaClient();

const reportErrorToSlackPlugin: ApolloServerPlugin = {
  async requestDidStart() {
    return {
      async didEncounterErrors(requestContext) {
        for (const error of requestContext.errors) {
          const err = error.originalError || error;
          if (err.message != "You are not authenticated.")
            report("Error", [
              {
                type: "section",
                text: {
                  type: "mrkdwn",
                  text: `Error: ${err.name}`,
                },
              },
              {
                type: "section",
                text: {
                  type: "mrkdwn",
                  text: `Message: ${err.message}`,
                },
              },
              {
                type: "section",
                text: {
                  type: "mrkdwn",
                  text: `Stack trace:\n\`\`\`${err.stack}\`\`\``,
                },
              },
            ]);
        }
        return;
      },
    };
  },
};

async function startApolloServer() {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const server = new ApolloServer<any>({
    typeDefs: typeDefs,
    resolvers: resolvers,
    csrfPrevention: true,
    introspection: true,
    plugins: [
      reportErrorToSlackPlugin,
      ApolloServerPluginUsageReporting({
        // If you pass unmodified: true to the usage reporting
        // plugin, Apollo Studio receives ALL error details
        sendErrors: { unmodified: true },
        sendTraces: true,
      }),
    ],
  });

  const { url } = await startStandaloneServer(server, {
    context: async ({ req }) => {
      const token = getAuthToken(req);
      return {
        token,
        ...(await authenticate(token, prisma)),
        dataSources: {
          prisma: prisma,
        },
      };
    },
    listen: { port: 8080 },
  });

  // eslint-disable-next-line no-console
  console.info(`🚀  Server readyyyy at ${url}`);
}

startApolloServer();
