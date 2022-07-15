"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const rootResolvers_1 = require("./graphql/resolvers/rootResolvers");
const rootTypeDefs_1 = require("./graphql/typeDefs/rootTypeDefs");
const firebase_service_1 = require("./service/firebase_service");
const apollo_server_1 = require("apollo-server");
const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();
const { logger } = require("./service/logging_service");
const server = new apollo_server_1.ApolloServer({
    typeDefs: rootTypeDefs_1.typeDefs,
    resolvers: rootResolvers_1.resolvers,
    csrfPrevention: true,
    plugins: [logger],
    dataSources: () => {
        return {
            prisma: prisma,
        };
    },
    context: ({ req }) => __awaiter(void 0, void 0, void 0, function* () {
        // Get the user token from the headers and put it into the coin.
        const token = (0, firebase_service_1.getAuthToken)(req);
        const authenticationInfo = yield (0, firebase_service_1.authenticate)(token);
        return authenticationInfo;
    }),
});
server.listen({ port: 8080 }).then(({ url }) => {
    console.log(`🚀 ${new Date().toISOString()}  Server ready at: ${url}`);
});
//# sourceMappingURL=index.js.map