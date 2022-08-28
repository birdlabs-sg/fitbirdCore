-- CreateEnum
CREATE TYPE "WorkoutState" AS ENUM ('UNATTEMPTED', 'IN_PROGRESS', 'COMPLETED', 'DRAFT');

-- AlterTable
ALTER TABLE "Workout" ADD COLUMN     "workout_state" "WorkoutState" NOT NULL DEFAULT E'UNATTEMPTED';
