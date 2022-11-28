import { onlyAuthenticated } from '../../../service/firebase/firebase_service';
import { AppContext } from '../../../types/contextType';
import { WorkoutType } from '@prisma/client';
import { bodyweight_challenge } from '../../../service/workout_manager/Presets/bodyweight_challenge';
import { Workout } from '@prisma/client';
import { MutationCreateChallengeArgs } from '../../../types/graphql';
import { convertPresetIntoExcerciseSetGroups } from '../../../service/workout_manager/utils';
export async function createChallenge(
    _: unknown,
    args:MutationCreateChallengeArgs,
    context: AppContext
  ) {
    onlyAuthenticated(context);
    const prisma = context.dataSources.prisma;  
    const {presetPreset_id}=args
    let workouts:Workout[] = []
    const preset = await prisma.challengePreset.findFirst({
      where:{
        challengePreset_id:parseInt(presetPreset_id)
      },
      include:{
        preset_workouts:{
          include:{
            preset_excercise_set_groups:{
              include:{
                preset_excercise_sets:true
              }
            }
          }
          
        }
        
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
    
    for(let i =0;i< preset.preset_workouts.length;i++){
    let workout:any={
      user: { connect: { user_id: context.base_user.User.user_id } },
      workout_type: WorkoutType.CHALLENGE,
      workout_name: bodyweight_challenge[i].workout_name,
      life_span: 1, //life_span to be confirmed 1/0 <--
      order_index:i+1,
      excercise_set_groups:{create:convertPresetIntoExcerciseSetGroups(preset.preset_workouts[0].preset_excercise_set_groups)},
    }
      workouts.push(workout);
    }
    await prisma.challenge.create({
      data: {
      workouts:{create: workouts},
      is_active:true,
      completion_status:false,
      user: { connect: { user_id: context.base_user.User.user_id } },
      challengePreset:{ connect: { challengePreset_id:parseInt(presetPreset_id) } },
      }
    });
   
    return {
      code: '200',
      success: true,
      message: 'Successfully created a challenge.',
      
    };
  }