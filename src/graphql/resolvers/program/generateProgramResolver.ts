import { onlyAuthenticated } from "../../../service/firebase/firebase_service";
import { workoutGeneratorV2 } from "../../../service/workout_manager/workout_generator/workout_generator";
import { AppContext } from "../../../types/contextType";
import { MutationGenerateProgramArgs } from "../../../types/graphql";

/**
 * Generates @no_of_workouts number of workouts based on expert guidelines.
 * The generated program are of type: ProgramType.AI_MANAGED
 */
export const generateProgramResolver = async (
  _: unknown,
  { initial_days }: MutationGenerateProgramArgs,
  context: AppContext
) => {
  onlyAuthenticated(context);
  // TODO: only allow users themselves to generate programs
  const generatedWorkotus = await workoutGeneratorV2(initial_days, context);
  return generatedWorkotus;
};
