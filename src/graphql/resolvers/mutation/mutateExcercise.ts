import { onlyAuthenticated, onlyAdmin } from "../../../service/firebase_service";


export const createExcercise = async ( _:any, args: any, context:any ) => {
    onlyAuthenticated(context)
    onlyAdmin(context)
    const prisma = context.dataSources.prisma
    const {target_regions, synergist_muscles, dynamic_stabilizer_muscles,stabilizer_muscles , ...otherArgs} = args;
    const targetRegionArray = target_regions.map((target_region_id:any) => ({muscle_region_id: target_region_id}))
    const synergistMusclesArray = synergist_muscles.map((synergist_muscles_id:any) => ({muscle_region_id: synergist_muscles_id}))
    const dynamicStabilizerMusclesArray = dynamic_stabilizer_muscles.map((dynamic_stabilizer_muscles_id:any) => ({muscle_region_id: dynamic_stabilizer_muscles_id}))
    const stabilizerMusclesArray = stabilizer_muscles.map((stabilizer_muscles_id:any) => ({muscle_region_id: stabilizer_muscles_id}))

    const newExcercise = await prisma.excercise.create({
        data: {
            ...otherArgs,
            target_regions: {
                connect: targetRegionArray
            },
            stabilizer_muscles: {
                connect: stabilizerMusclesArray
            },
            synergist_muscles: {
                connect: synergistMusclesArray
            },
            dynamic_stabilizer_muscles: {
                connect: dynamicStabilizerMusclesArray
            },
        },
        include: {
            target_regions: true,
            stabilizer_muscles: true,
            synergist_muscles: true,
            dynamic_stabilizer_muscles: true,
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
    const {excercise_id,target_regions, synergist_muscles, dynamic_stabilizer_muscles,stabilizer_muscles , ...otherArgs} = args;
    const targetRegionArray = target_regions.map((target_region_id:any) => ({muscle_region_id: target_region_id}))
    const synergistMusclesArray = synergist_muscles.map((synergist_muscles_id:any) => ({muscle_region_id: synergist_muscles_id}))
    const dynamicStabilizerMusclesArray = dynamic_stabilizer_muscles.map((dynamic_stabilizer_muscles_id:any) => ({muscle_region_id: dynamic_stabilizer_muscles_id}))
    const stabilizerMusclesArray = stabilizer_muscles.map((stabilizer_muscles_id:any) => ({muscle_region_id: stabilizer_muscles_id}))

    const updatedExcercise = await prisma.excercise.update({
        where: {
            excercise_id : excercise_id
        },
        data:{
            ...otherArgs,
            target_regions: {
                set: targetRegionArray
            },
            stabilizer_muscles: {
                set: stabilizerMusclesArray
            },
            synergist_muscles: {
                set: synergistMusclesArray
            },
            dynamic_stabilizer_muscles: {
                set: dynamicStabilizerMusclesArray
            },
        },
        include: {
            target_regions: true,
            stabilizer_muscles: true,
            synergist_muscles: true,
            dynamic_stabilizer_muscles: true,
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