import { resolvers } from "./graphql/resolvers/rootResolvers";
import { typeDefs } from "./graphql/typeDefs/rootTypeDefs";
import { authenticate, getAuthToken } from "./service/firebase_service";
import { ApolloServer } from 'apollo-server';

const { PrismaClient } = require('@prisma/client')

const prisma = new PrismaClient()


const { logger } = require('./service/logging_service')

const server = new ApolloServer({
  typeDefs: typeDefs,
  resolvers: resolvers,
  csrfPrevention: true,
  plugins: [logger],
  dataSources: () => {
    return {
      prisma : prisma
    }
  },
  context: async ({ req } : any) => {
    // Get the user token from the headers and put it into the coin.
    const token = getAuthToken(req)
    const authenticationInfo = await authenticate(token)
    return authenticationInfo
  },
});

server.listen({port:8080}).then(({ url }) => {
  console.log(`🚀 ${new Date().toISOString()}  Server ready at: ${url}`);
});