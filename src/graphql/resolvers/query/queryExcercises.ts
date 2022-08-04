import { Equipment } from "@prisma/client";
const _ = require("lodash");
export const excercisesQueryResolver = async (
  parent: any,
  args: any,
  context: any,
  info: any
) => {
  const prisma = context.dataSources.prisma;
  const user_constaints = _.differenceWith(
    Object.keys(Equipment),
    context.user.equipment_accessible,
    _.isEqual
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
