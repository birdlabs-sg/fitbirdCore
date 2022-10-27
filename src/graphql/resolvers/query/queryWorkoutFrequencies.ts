import moment from "moment";
import { AppContext } from "../../../types/contextType";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";

export const workoutFrequencyQueryResolver = async (
  _: any,
  __: any,
  context: AppContext
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
        user_id: context.base_user.User!.user_id,
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
