// import { MutationUpdateBaseUserArgs } from "../../../types/graphql";
import { MutationUpdateBaseUserArgs } from "../../../types/graphql";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { AppContext } from "../../../types/contextType";

export const updateBaseUserResolver = async (
  _: any,
  { fcm_tokens, ...restArgs }: MutationUpdateBaseUserArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  let updatedBaseUser;
  if (fcm_tokens) {
    for (var fcm_token of fcm_tokens) {
      const current_token = await prisma.fCMToken.findUnique({
        where: {
          token: fcm_token,
        },
      });
      if (current_token == null) {
        await prisma.fCMToken.create({
          data: {
            token: fcm_token!,
            baseUserBase_user_id: context.user.base_user_id,
          },
        });
      } else {
        await prisma.fCMToken.update({
          where: {
            token: fcm_token,
          },
          data: {
            date_issued: new Date(Date.now()),
          },
        });
      }
    }
  }

  updatedBaseUser = await prisma.baseUser.update({
    where: {
      base_user_id: context.user.base_user_id,
    },
    data: restArgs,
  });

  return {
    code: "200",
    success: true,
    message: "Successfully updated your profile!",
    user: updatedBaseUser,
  };
};
