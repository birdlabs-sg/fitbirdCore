import { ForbiddenError } from 'apollo-server';
import { onlyAuthenticated } from "../../../service/firebase_service";

export const generateWorkouts = async ( _:any, args: any, context:any ) => {
    onlyAuthenticated(context)
    // custom logic for generating workouts based on user type
}

export const createWorkout = async ( _:any, args: any, context:any ) => {
    // only used when the user wishes to create new workout on existing ones
    onlyAuthenticated(context)
    const prisma = context.dataSources.prisma
    const {excercise_sets, ...otherArgs} = args
    
    // Get all the active workouts
    const active_workouts = await prisma.workout.findMany({
        where: {
            date_completed : null
        },
    })

    // get the highest order index
    var highest_order_index = -1
    for (var i = 0; i < active_workouts.length; i++) {
        if ( active_workouts[i].order_index > highest_order_index) {
            highest_order_index = active_workouts[i].order_index;
        }
    }

    // create a new workout based on provided arguments and slot it behind the last active workout
    const newWorkout = await prisma.workout.create({
        data: {
            user_id: context.user.user_id,
            order_index: highest_order_index + 1,
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

export const updateWorkoutOrder = async ( _:any, args: any, context:any ) => {
    let {oldIndex, newIndex} = args;
    const prisma = context.dataSources.prisma
    const active_workouts = await prisma.workout.findMany({
        where: {
            date_completed : null
        },
        orderBy: {
            order_index: 'asc',
        },
    })
    if (oldIndex < newIndex) {
        newIndex -= 1;
    }
    const workout = active_workouts.splice(oldIndex,1)[0]
    active_workouts.splice(newIndex, 0, workout);
    for (var i = 0; i< active_workouts.length; i++) {
        const {workout_id} = active_workouts[i]; 
        await prisma.workout.update({
            where: {
                workout_id : workout_id
            },
            data: {
                order_index: i,
                excercise_sets: undefined
            },
        })
    }
    return await prisma.workout.findMany({
        where: {
            user_id: context.user_id,
            date_completed: null
        },
        orderBy: {
            order_index: 'asc'
        }
    });
}

export const updateWorkout = async ( _:any, args: any, context:any ) => {
    // responsibility of reordering is done on the frontend
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

    if (targetWorkout.user_id != context.user.user_id) {
        throw new ForbiddenError('You are not authororized to remove this object.');
    }

    const deletedWorkout = await prisma.workout.delete({
        where: {
            workout_id: args.workout_id,
        },
    })
    // Reorder the remaining active workouts
    const active_workouts = await prisma.workout.findMany({
        where: {
            date_completed : null
        },
        orderBy: {
            order_index: 'asc',
        },
    })

    for (var i = 0; i < active_workouts.length; i++) {
        const {order_index, workout_id , ...otherArgs} = active_workouts[i] 
        if (i != order_index) {
            await prisma.workout.update({
                where: {
                    workout_id : workout_id
                },
                data: {
                    order_index: i,
                    ...otherArgs, 
                    excercise_sets: undefined
                },
            })
        }
    }

    return {
        code: "200",
        success: true,
        message: "Successfully deleted your workout!",
        workout: deletedWorkout
    } 
}