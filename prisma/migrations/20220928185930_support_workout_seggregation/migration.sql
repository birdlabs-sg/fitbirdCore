-- CreateEnum
CREATE TYPE "WorkoutType" AS ENUM ('AI_MANAGED', 'SELF_MANAGED', 'COACH_MANAGED');

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "workout_type_enrollment" "WorkoutType" NOT NULL DEFAULT E'SELF_MANAGED';

-- AlterTable
ALTER TABLE "Workout" ADD COLUMN     "workout_type" "WorkoutType" NOT NULL DEFAULT E'SELF_MANAGED';
