import { AppContext } from "../../../types/contextType";
import { generateWorkoutReminder } from "../../../service/notification/notification_service";

export const generateWorkoutReminderResolver = async (
  _: unknown,
  __: unknown,
  context: AppContext
) => {
  await generateWorkoutReminder(context);
  return {
    code: "200",
    success: true,
    message: "Successfully generated notification",
  };
};
