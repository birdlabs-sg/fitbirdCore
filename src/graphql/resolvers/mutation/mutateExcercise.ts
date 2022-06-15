import { onlyAuthenticated, onlyAdmin } from "../../../service/firebase_service";


export const createExcercise = async ( _:any, args: any, context:any ) => {
    onlyAuthenticated(context)
    onlyAdmin(context)
    const prisma = context.dataSources.prisma
    const {target_regions, ...otherArgs} = args;
    const targetRegionArray = target_regions.map((target_region_id:any) => ({muscle_region_id: target_region_id}))
    const newExcercise = await prisma.excercise.create({
        data: {
            ...otherArgs,
            target_regions: {
                connect: targetRegionArray
            },
        },
        include: {
            target_regions: true
        }
    })
    return {
        code: "200",
        success: true,
        message: "Successfully created an excercise!",
        excercise: newExcercise
    }
}

export const updateExcercise = async ( _:any, args: any, context:any ) => {
    onlyAuthenticated(context)
    onlyAdmin(context)
    const prisma = context.dataSources.prisma
    const {excercise_id, target_regions, ...otherArgs} = args;
    const targetRegionArray = target_regions.map((target_region_id:any) => ({muscle_region_id: target_region_id}))

    const updatedExcercise = await prisma.excercise.update({
        where: {
            excercise_id : excercise_id
        },
        data:{
            ...otherArgs,
            target_regions: {
                set: targetRegionArray
            }    
        },
        include: {
            target_regions: true
        }
    })

    return {
        code: "200",
        success: true,
        message: "Successfully updated the specified excercise!",
        excercise: updatedExcercise
    }
}


export const deleteExcercise = async ( _:any, args: any, context:any ) => {
    onlyAuthenticated(context)
    onlyAdmin(context)
    const prisma = context.dataSources.prisma
    const deletedExcercise = await prisma.excercise.delete({
        where: {
            excercise_id: args.excercise_id,
        },
    })
    return {
        code: "200",
        success: true,
        message: "Successfully deleted the specified excercise.",
        excercise: deletedExcercise
    } 
}