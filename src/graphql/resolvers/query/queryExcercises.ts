import { Equipment } from "@prisma/client";
import { AppContext } from "../../../types/contextType";
<<<<<<< Updated upstream
=======
import {
  isUser,
  onlyCoach,
  onlyAuthenticated,
} from "../../../service/firebase/firebase_service";
>>>>>>> Stashed changes
const lodash = require("lodash");
export const excercisesQueryResolver = async (
  _: any,
  __: any,
  context: AppContext
) => {
  const prisma = context.dataSources.prisma;
<<<<<<< Updated upstream
  const user_constaints = lodash.differenceWith(
    Object.keys(Equipment),
    context.user.equipment_accessible,
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
=======
  if (isUser(context)) {
    const user_constaints = lodash.differenceWith(
      Object.keys(Equipment),
      context.base_user.User!.user_id,
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
>>>>>>> Stashed changes
};
