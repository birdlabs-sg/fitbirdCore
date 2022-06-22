import { onlyAdmin, onlyAuthenticated } from "../../../service/firebase_service";


export const updateUser = async ( _:any, args: any, context:any ) => {
    onlyAuthenticated(context)
    const prisma = context.dataSources.prisma
    // conduct check that the measurement object belongs to the user.
    console.log(context.user);
    console.log(args)
    let updatedUser;
    try {
        updatedUser = await prisma.user.update({
            where: {
                user_id : context.user.user_id
            },
            data:args,
        })
    } catch (e) {
        console.log(e)
    }

    return {
        code: "200",
        success: true,
        message: "Successfully updated your profile!",
        user: updatedUser
    } 
}

    