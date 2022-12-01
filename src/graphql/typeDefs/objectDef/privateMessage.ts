import gql from "graphql-tag";

export const privateMessage = gql`
    "Represents a list of private messages."
    type PrivateMessage {
       message_id:Int
       date_issued:Date
       message_content:String!
       sender_id:Int
       receiver_id:Int
    }

`