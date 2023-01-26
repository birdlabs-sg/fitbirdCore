import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { AppContext } from "../../../types/contextType";

export const deletePrivateMessageResolver = async (
  _: unknown,
  args: any,
  context: AppContext
) => {
  onlyAuthenticated(context);
  const prisma = context.dataSources.prisma;
  const { message_id } = args;
  await prisma.privateMessage.delete({
    where: {
      message_id: message_id,
    },
  });
  return {
    code: "200",
    success: true,
    message: "Successfully deleted a message!",
  };
};
