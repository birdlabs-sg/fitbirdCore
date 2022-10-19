import gql from "graphql-tag";

export const mutateNotification = gql`
  "Response if a signup event is successful"
  type NotificationResponse implements MutationResponse {
    code: String!
    success: Boolean!
    message: String!
  }

  "[PUBLIC] Mutation to create a new notification with firebase"
  type Mutation {
    generateNotification(
      token: String!
      title: String!
      body: String!
    ): NotificationResponse

    generateWorkoutReminder: NotificationResponse
  }
`;
