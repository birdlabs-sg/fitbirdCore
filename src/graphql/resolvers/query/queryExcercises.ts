import { Equipment } from "@prisma/client";
import { AppContext } from "../../../types/contextType";
import {
  isUser,
  onlyCoach,
  onlyAuthenticated,
} from "../../../service/firebase/firebase_service";
import lodash from "lodash";
export const excercisesQueryResolver = async (
  _: unknown,
  __: unknown,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  if (isUser(context)) {
    const user_constaints = lodash.differenceWith(
      Object.keys(Equipment),
      context.base_user!.User!.equipment_accessible,
      lodash.isEqual
    ) as Equipment[];
    const filteredExcercises = await prisma.excercise.findMany({
      where: {
        NOT: {
          equipment_required: {
            hasSome: user_constaints,
          },
        },
      },
    });

    return filteredExcercises;
  } else {
    onlyCoach(context);
    return await prisma.excercise.findMany({});
  }
};
