import { onlyAuthenticated } from "../../../service/firebase_service";


export const createExcerciseBlock = async ( _:any, args: any, context:any ) => {
    onlyAuthenticated(context)
    const prisma = context.dataSources.prisma
    const newExcerciseBlock = await prisma.excerciseBlock.create({
        data: args,
        include: {
            workout: true,
            excercise: true,
        }
    })

    return {
        code: "200",
        success: true,
        message: "Successfully created an excercise block",
        excercise_block: newExcerciseBlock
    }
}

export const updateExcerciseBlock = async ( _:any, args: any, context:any ) => {
    onlyAuthenticated(context)
    const {workout_id,excercise_id, weight,weight_unit,reps_per_set,sets, ...otherArgs} = args

    const prisma = context.dataSources.prisma
    const updatedExcerciseBlock = await prisma.excerciseBlock.update({
        where: {
            workout_id_excercise_id_weight_weight_unit_reps_per_set_sets: 
            { 
                workout_id: workout_id,
                excercise_id: excercise_id,
                weight: weight,
                weight_unit: weight_unit,
                reps_per_set: reps_per_set,
                sets: sets,
            }
        },
        data: otherArgs,
        include: {
            workout: true,
            excercise: true,
        }
    })
    return {
        code: "200",
        success: true,
        message: "Successfully updated the specified excercise block!",
        excercise_block: updatedExcerciseBlock
    }
}


export const deleteExcerciseBlock = async ( _:any, args: any, context:any ) => {
    onlyAuthenticated(context)
    const prisma = context.dataSources.prisma
    const deletedExcerciseBlock = await prisma.excerciseBlock.delete({
        where: {
            workout_id_excercise_id_weight_weight_unit_reps_per_set_sets: 
            { 
                workout_id: args.workout_id,
                excercise_id: args.excercise_id,
                weight: args.weight,
                weight_unit: args.weight_unit,
                reps_per_set: args.reps_per_set,
                sets: args.sets,
            }
        }
    })
    return {
        code: "200",
        success: true,
        message: "Successfully removed the specified excercise block!",
        excercise_block: deletedExcerciseBlock
    } 
}