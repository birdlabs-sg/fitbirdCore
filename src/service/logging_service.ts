// A GraphQLExtension that implements the existing logFunction interface. Note
// that now that custom extensions are supported, you may just want to do your
// logging as a GraphQLExtension rather than write a LogFunction.

export const logger = {
  async serverWillStart() {
    console.log("🚀  Server initializing...");
  },
  async requestDidStart(requestContext: any) {
    if (requestContext.request.operationName !== "IntrospectionQuery") {
      console.log(`[REQUEST] ${new Date()}`);
    }
    return {
      async parsingDidStart() {
        return async (err: any) => {
          if (err) {
            console.error(err);
          }
        };
      },
      async validationDidStart() {
        // This end hook is unique in that it can receive an array of errors,
        // which will contain every validation error that occurred.
        return async (errs: any) => {
          if (errs) {
            errs.forEach((err: any) => console.error(err));
          }
        };
      },
      async executionDidStart() {
        return {
          async executionDidEnd(err: any) {
            if (err) {
              console.error(err);
            }
          },
        };
      },
      async willSendResponse(context: any) {
        if (context.request.operationName !== "IntrospectionQuery") {
          console.log(`[RESPONSE] ${new Date()}`);
        }
      },
    };
  },
};
