import { Equipment } from "@prisma/client";
import { AppContext } from "../../../types/contextType";
const lodash = require("lodash");
export const excercisesQueryResolver = async (
  _: any,
  __: any,
  context: AppContext
) => {
  const prisma = context.dataSources.prisma;
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
};
