import { Equipment } from "@prisma/client";
import { AppContext } from "../../../types/contextType";
import {
  isUser,
  onlyCoach,
  onlyAuthenticated,
} from "../../../service/firebase/firebase_service";
const lodash = require("lodash");
export const excercisesQueryResolver = async (
  _: any,
  __: any,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  if (isUser(context)) {
    const user_constaints = lodash.differenceWith(
      Object.keys(Equipment),
      context.base_user!.User!.equipment_accessible,
      lodash.isEqual
    );
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
