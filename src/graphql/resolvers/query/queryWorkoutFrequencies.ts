import moment from "moment";
import { onlyAuthenticated } from "../../../service/firebase_service";

export const workoutFrequencyQueryResolver = async (
  parent: any,
  args: any,
  context: any,
  info: any
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;

  function getWeekRange(week = 1) {
    var weekStart = moment().add(week, "weeks").startOf("week");
    var weekEnd = moment().add(week, "weeks").endOf("week");
    return { startDate: weekStart.toDate(), endDate: weekEnd.toDate() };
  }
  const workoutFrequencies = [];

  for (let i = 0; i > -6; i--) {
    const { startDate, endDate } = getWeekRange(i);
    const count = await prisma.workout.aggregate({
      _count: true,
      where: {
        workoutGroup: {
          user_id: context.user.user_id,
        },
        date_completed: {
          gte: startDate,
          lt: endDate,
        },
      },
    });
    workoutFrequencies.unshift({
      workout_count: count._count,
      week_identifier: moment(startDate).format("MMM DD"),
    });
  }
  return workoutFrequencies;
};
