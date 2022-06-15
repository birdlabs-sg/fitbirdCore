import { onlyAuthenticated } from "../../../service/firebase_service"

export const notificationsQueryResolver  = async (parent: any, args: any, context: any, info: any) => {
    onlyAuthenticated(context)
    const prisma = context.dataSources.prisma
    return await prisma.notification.findMany({
        where: { user_id: context.user.user_id }
    })
}