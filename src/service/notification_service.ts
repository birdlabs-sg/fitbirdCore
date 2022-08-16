import * as admin from "firebase-admin";

// Generates excerciseMetadata if it's not available for any of the excercises in a workout
export const generateNotification = async (
  token: string,
  title: string,
  body: string
) => {
  return await admin.messaging().send({
    token: token,
    notification: {
      title: title,
      body: body,
    },
    android: {
      priority: "high",
    },
    apns: {
      payload: {
        aps: {
          contentAvailable: true,
        },
      },
      headers: {
        "apns-priority": "10",
      },
    },
  });
};
