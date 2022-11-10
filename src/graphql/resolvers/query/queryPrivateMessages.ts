import { AppContext } from "../../../types/contextType";
import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { QueryGetPrivateMessagesArgs } from "../../../types/graphql";

export const privateMessagesQueryResolver = async (
    _: unknown,
    args: QueryGetPrivateMessagesArgs,
    context: AppContext

)=>{
    onlyAuthenticated(context)
    const prisma = context.dataSources.prisma;
    const {pair_id}=args
    return await prisma.privateMessage.findMany({
        where:{
            OR: [
                    {
                        receiver_id:context.base_user.base_user_id,
                        sender_id:parseInt(pair_id)
                    },
                    {   receiver_id:parseInt(pair_id),
                        sender_id:context.base_user.base_user_id 
                    },
                ],
            }
    })

    
}