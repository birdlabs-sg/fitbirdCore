import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { MutationUpdateUserArgs } from "../../../types/graphql";
import { AppContext } from "../../../types/contextType";

export const updateUser = async (
  _: any,
  args: MutationUpdateUserArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);

  const prisma = context.dataSources.prisma;
  const updatedUser = await prisma.user.update({
    where: {
      user_id: context.base_user?.User?.user_id,
    },
    data: args,
  });

  return {
    code: "200",
    success: true,
    message: "Successfully updated your profile!",
    user: updatedUser,
  };
};
