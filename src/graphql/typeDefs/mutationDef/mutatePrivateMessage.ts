import gql from "graphql-tag";


export const mutatePrivateMessage = gql`
"Response if a PrivateMessage event is successful"
  type MutatePrivateMessageResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
    privateMessage: PrivateMessage
  }
  type Mutation {
    "[PROTECTED] Creates a PrivateMessage Object."
    createPrivateMessage(
        message_content:String!
        receiver_id:ID!
    ):MutatePrivateMessageResponse
  }


`