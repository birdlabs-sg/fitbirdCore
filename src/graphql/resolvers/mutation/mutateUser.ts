import { onlyAdmin, onlyAuthenticated } from "../../../service/firebase_service";


export const updateUser = async ( _:any, args: any, context:any ) => {
    console.log("ss")
    onlyAuthenticated(context)
    const prisma = context.dataSources.prisma
    // conduct check that the measurement object belongs to the user.
    const updatedUser = await prisma.user.update({
        where: {
            user_id : context.user.user_id
        },
        data:args,
    })

    console.log(updatedUser);

    return {
        code: "200",
        success: true,
        message: "Successfully updated your profile!",
        user: updatedUser
    } 
}

    