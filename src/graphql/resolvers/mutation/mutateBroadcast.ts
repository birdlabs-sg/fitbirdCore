import { onlyAuthenticated, onlyAdmin } from "../../../service/firebase_service";


export const createBroadcast = async ( _:any, args: any, context:any ) => {
    onlyAuthenticated(context)
    onlyAdmin(context)
    const prisma = context.dataSources.prisma
    const {users, ...otherArgs} = args;
    const usersArray = users.map((user_id:any) => ({user_id: user_id}))
    const newBroadcast = await prisma.broadCast.create({
        data: {
            ...otherArgs,
            users: {
                connect: usersArray
            },
        },
        include: {
            users: true
        }
    })

    return {
        code: "200",
        success: true,
        message: "Successfully created a broadcast!",
        broadcast: newBroadcast
    }
}

export const updateBroadcast = async ( _:any, args: any, context:any ) => {
    onlyAuthenticated(context)
    onlyAdmin(context)
    const prisma = context.dataSources.prisma
    const {broad_cast_id, users, ...otherArgs} = args;
    const usersArray = users.map((user_id:any) => ({user_id: user_id}))

    const updatedBroadcast = await prisma.broadCast.update({
        where: {
            broad_cast_id : broad_cast_id
        },
        data:{
            ...otherArgs,
            users: {
                set: usersArray
            }    
        },
        include: {
            users: true
        }
    })

    return {
        code: "200",
        success: true,
        message: "Successfully updated the specified broadcast!",
        broadcast: updatedBroadcast
    }
}


export const deleteBroadcast = async ( _:any, args: any, context:any ) => {
    onlyAuthenticated(context)
    onlyAdmin(context)
    const prisma = context.dataSources.prisma
    const deletedBroadcast = await prisma.broadCast.delete({
        where: {
            broad_cast_id: args.broad_cast_id,
        },
    })
    return {
        code: "200",
        success: true,
        message: "Successfully deleted the specified broadcast.",
        broadcast: deletedBroadcast
    } 
}