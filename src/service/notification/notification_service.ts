import * as admin from "firebase-admin";
import { AppContext } from "../../types/contextType";
import moment from "moment";
import { DayOfWeek } from "@prisma/client";

// Generates excerciseMetadata if it's not available for any of the excercises in a workout
export const generateNotification = async (
  context: AppContext,
  token: string,
  title: string,
  body: string
) => {
  const prisma = context.dataSources.prisma;
  try {
    await admin.messaging().send({
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
            mutableContent: true,
          },
        },
        headers: {
          "apns-priority": "10",
        },
      },
    });
  } catch (error) {
    if (
      error.errorInfo?.code === "messaging/invalid-argument" ||
      error.errorInfo?.code === "messaging/unregistered"
    ) {
      await prisma.fCMToken.delete({
        where: {
          token: token,
        },
      });
      // The client does not exist
    }
  }
};

// This function is called by the cloud scheduler every 1.5 days
// Only sends notification out to users who have fcm_token
export const generateWorkoutReminder = async (context: AppContext) => {
  const prisma = context.dataSources.prisma;
  let currentDay: DayOfWeek;
  switch (moment().weekday()) {
    case 1:
      currentDay = DayOfWeek.MONDAY;
      break;
    case 2:
      currentDay = DayOfWeek.TUESDAY;
      break;
    case 3:
      currentDay = DayOfWeek.WEDNESDAY;
      break;
    case 4:
      currentDay = DayOfWeek.THURSDAY;
      break;
    case 5:
      currentDay = DayOfWeek.FRIDAY;
      break;
    case 6:
      currentDay = DayOfWeek.SATURDAY;
      break;
    default:
      currentDay = DayOfWeek.SUNDAY;
      break;
  }
  const list_of_users = await prisma.baseUser.findMany({
    where: {
      fcm_tokens: {
        some: {},
      },
      NOT: {
        User: null,
      },
    },
    include: {
      User: true,
      fcm_tokens: true,
    },
  });

  const list_of_token_and_content = await Promise.all(
    list_of_users.map(async function (user) {
      let content_string = "";
      let title_string = "";
      const tokens = user.fcm_tokens;
      if (!user.User?.current_program_enrollment_id) {
        return;
      }
      const activeProgram = await prisma.program.findUnique({
        where: {
          program_id: user.User.current_program_enrollment_id,
        },
        include: {
          workouts: {
            where: {
              date_closed: null,
            },
            include: {
              excercise_set_groups: true,
            },
          },
        },
      });
      let nextWorkout;
      if (activeProgram?.workouts.length) {
        nextWorkout = activeProgram.workouts.find(
          (workout) => workout.dayOfWeek === currentDay
        );
      }
      if (nextWorkout != null) {
        title_string = "Your next workout";
        content_string = nextWorkout.excercise_set_groups
          .map((exercise_set_group) => exercise_set_group.excercise_name)
          .join(" → ");
      } else {
        title_string = "Time to get into a routine!";
        content_string =
          "Get your personalized workout routines using fitbird's AI.";
      }
      return {
        tokens: tokens,
        content_string: content_string,
        title_string: title_string,
      };
    })
  );

  for (const token_and_content of list_of_token_and_content) {
    if (token_and_content) {
      const { tokens, content_string, title_string } = token_and_content;
      for (const fcmToken of tokens) {
        await generateNotification(
          context,
          fcmToken.token,
          title_string,
          content_string
        );
      }
    }
  }
};
