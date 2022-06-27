import { ForbiddenError } from 'apollo-server';
import { onlyAuthenticated } from "../../../service/firebase_service";


export const createWorkout = async ( _:any, args: any, context:any ) => {
    onlyAuthenticated(context)
    const prisma = context.dataSources.prisma
    const {excercise_sets, ...otherArgs} = args

    const newWorkout = await prisma.workout.create({
        data: {
            user_id: context.user.user_id,
            ...otherArgs,
            excercise_sets: { 
                create: excercise_sets
            }
        },
        include: {
            excercise_sets: true,
        }
    })

    return {
        code: "200",
        success: true,
        message: "Successfully created a workout.",
        workout: newWorkout
    }
}

export const updateWorkout = async ( _:any, args: any, context:any ) => {
    onlyAuthenticated(context)
    const {workout_id, excercise_sets, ...otherArgs} = args
    const prisma = context.dataSources.prisma

    // note: you have to send in all the excercise_sets cos it'll be if it's not present
    const targetWorkout = await prisma.workout.findUnique({
        where: {
            workout_id: workout_id
        }
    })
    if (targetWorkout.user_id !== context.user.user_id) {
        throw new ForbiddenError('You are not authororized to remove this object.');
    }

    const updatedWorkout = await prisma.workout.update({
        where: {
            workout_id : workout_id
        },
        data:{
            ...otherArgs, 
            excercise_sets: {
                deleteMany: {},
                createMany: {data: excercise_sets},
            }
        },
        include: {
            excercise_sets: true,
        }
    })

    return {
        code: "200",
        success: true,
        message: "Successfully updated your workout!",
        workout: updatedWorkout
    } 

}


export const deleteWorkout = async ( _:any, args: any, context:any ) => {
    onlyAuthenticated(context)
    const prisma = context.dataSources.prisma

    // conduct check that the measurement object belongs to the user.
    const targetWorkout = await prisma.workout.findUnique({
        where: {
            workout_id: args.workout_id
        }
    })
    if (targetWorkout.user_id !== context.user.user_id) {
        throw new ForbiddenError('You are not authororized to remove this object.');
    }

    const deletedWorkout = await prisma.workout.delete({
        where: {
            workout_id: args.workout_id,
        },
    })
    return {
        code: "200",
        success: true,
        message: "Successfully deleted your workout!",
        workout: deletedWorkout
    } 
}