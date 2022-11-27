import { onlyAuthenticated } from '../../../service/firebase/firebase_service';
import { AppContext } from '../../../types/contextType';
import { WorkoutType } from '@prisma/client';
import { bodyweight_challenge } from '../../../service/workout_manager/Presets/bodyweight_challenge';
import { Workout } from '@prisma/client';
export async function createChallenge(
    _: unknown,
    args:any,
    context: AppContext
  ) {
    onlyAuthenticated(context);
    const prisma = context.dataSources.prisma;  
    const {preset_id}=args
    let workouts:Workout[] = []
    const preset = await prisma.challengePreset.findFirst({
      where:{
        challengePreset_id:preset_id
      },
      include:{
        preset_Workouts:true
      }
    })
    await prisma.challenge.updateMany({
      where: {
        user_id: context.base_user.User.user_id,
      },
      data: {
        is_active: false
      }
    });

    for(let i =0;i< preset.preset_Workouts.length;i++){
    let workout:any={
      user: { connect: { user_id: context.base_user.User.user_id } },
      workout_type: WorkoutType.CHALLENGE,
      workout_name: bodyweight_challenge[i].workout_name,
      life_span: 1,
      order_index:i+1,
      excercise_set_groups:{create:bodyweight_challenge[i].excercise_set_groups},
      Challenge :{connect:{challengeChallenge_id:preset.challengePreset_id}}
    }
      workouts.push(workout);
    }

    const challenge = await prisma.challenge.create({
      data: {
      workouts:{create: workouts},
      is_active:true,
      completion_status:false,
      user: { connect: { user_id: context.base_user.User.user_id } },
      challengePreset:{ connect: { challengePreset_id:preset_id } },
      }
    });
   
    return {
      code: '200',
      success: true,
      message: 'Successfully created a workout.',
      challenge: challenge
    };
  }