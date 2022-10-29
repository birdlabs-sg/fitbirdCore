import { Prisma } from "@prisma/client";
import {
  ExcerciseSetInput,
  Maybe,
  FailureReason,
  ExcerciseSetGroupState,
} from "./graphql";

/**
 * Type for ExerciseSetGroups with exercise_sets, without the exercise_metadata
 */
export declare type PrismaExerciseSetGroupCreateArgs = {
  excercise_name: string;
  excercise_set_group_state: ExcerciseSetGroupState;
  excercise_sets: ExcerciseSetInput[];
  failure_reason?: Maybe<FailureReason> | undefined;
};

export declare type PrismaFormattedExerciseSetGroupCreateArgs = {
  excercise_name: string;
  excercise_set_group_state: ExcerciseSetGroupState;
  excercise_sets: {
    create: ExcerciseSetInput[];
  };
  failure_reason?: FailureReason | undefined;
};

// This helps to add more fields into the generated types
// 2: Define a type that only contains a subset of the scalar fields
const WorkoutWithExerciseSets = Prisma.validator<Prisma.WorkoutArgs>()({
  include: { excercise_set_groups: { include: { excercise_sets: true } } },
});

// 3: This type will include a user and all their posts
export declare type WorkoutWithExerciseSets = Prisma.WorkoutGetPayload<
  typeof WorkoutWithExerciseSets
>;
