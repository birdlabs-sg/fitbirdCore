import { onlyAuthenticated } from "../../../service/firebase_service"
import { onlyAdmin } from "../../../service/firebase_service"

export const usersQueryResolver = async (parent: any, args: any, context: any, info: any) => {
    onlyAuthenticated(context)
    onlyAdmin(context)
    const prisma = context.dataSources.prisma
    // reject non admins. Exception will be thrown if not
    // const requester_user_id = context.user_id
    return await prisma.user.findMany()
}