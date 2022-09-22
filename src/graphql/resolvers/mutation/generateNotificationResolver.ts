import { AppContext } from "../../../types/contextType";
import { MutationGenerateNotificationArgs } from "../../../types/graphql";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { generateNotification } from "../../../service/notification/notification_service";

export const generateNotificationResolver = async (
  _: any,
  args: MutationGenerateNotificationArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const { token, title, body } = args;
  await generateNotification(token, title, body);
  return {
    code: "200",
    success: true,
    message: "Successfully generated notification",
  };
};
