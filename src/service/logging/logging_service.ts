// A GraphQLExtension that implements the existing logFunction interface. Note
// that now that custom extensions are supported, you may just want to do your
// logging as a GraphQLExtension rather than write a LogFunction.

import { Context } from "vm";

export const logger = {
  async serverWillStart() {
    console.log("🚀  Server initializing...");
  },
  async requestDidStart(requestContext: Context) {
    if (requestContext.request.operationName !== "IntrospectionQuery") {
      console.log(`[REQUEST] ${new Date()}`);
    }
    return {
      async parsingDidStart() {
        return async (err: string) => {
          if (err) {
            console.error(err);
          }
        };
      },
      async validationDidStart() {
        // This end hook is unique in that it can receive an array of errors,
        // which will contain every validation error that occurred.
        return async (errs: string[]) => {
          if (errs) {
            errs.forEach((err) => console.error(err));
          }
        };
      },
      async executionDidStart() {
        return {
          async executionDidEnd(err: string) {
            if (err) {
              console.error(err);
            }
          },
        };
      },
      async willSendResponse(context: Context) {
        if (context.request.operationName !== "IntrospectionQuery") {
          console.log(`[RESPONSE] ${new Date()}`);
        }
      },
    };
  },
};
