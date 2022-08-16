import { onlyAuthenticated } from "../../../service/firebase_service";
import { generateNotification } from "../../../service/notification_service";

export const generateNotificationResolver = async (
  _: any,
  args: any,
  context: any
) => {
  onlyAuthenticated(context);
  const { token, title, body } = args;
  const notificationLog = await generateNotification(token, title, body);
  console.log(`generated: ${notificationLog}`);
  return {
    code: "200",
    success: true,
    message: "Successfully generated notification",
  };
};
