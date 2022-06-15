import { onlyAuthenticated } from "../../../service/firebase_service"

export const workoutsQueryResolver = async (parent: any, args: any, context: any, info: any) => {
    // onlyAuthenticated(context)
    const prisma = context.dataSources.prisma
    console.log(await prisma.workout.findMany({
        where: {
            user_id: context.user_id
        },
        include: {
            excercise_block: true
        }
    }))
    return await prisma.workout.findMany({
        where: {
            user_id: context.user_id
        }
    })
}