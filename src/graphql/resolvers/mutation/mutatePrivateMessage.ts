import { MutationCreatePrivateMessageArgs } from '../../../types/graphql';
import { onlyAuthenticated } from '../../../service/firebase/firebase_service';
import { AppContext } from '../../../types/contextType';

export const createPrivateMessage = async (
    _: unknown,
    args: MutationCreatePrivateMessageArgs,
    context: AppContext
  ) => {
    onlyAuthenticated(context);
    const prisma = context.dataSources.prisma;
    const { receiver_id,message_content } = args;
    const newMessage = await prisma.privateMessage.create({
      data:{
        BaseUserSender:{connect:{base_user_id:context.base_user.base_user_id}},
        BaseUserReceiver:{connect:{base_user_id:parseInt(receiver_id)}},
        message_content:message_content,
      }
    });
    return {
      code: "200",
      success: true,
      message: "Successfully sent a message",
      privateMessage: newMessage,
    };
  };