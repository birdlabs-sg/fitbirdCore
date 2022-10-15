-- AlterTable
ALTER TABLE "ExcerciseSetGroup" ADD COLUMN     "rate_of_perceived_exertion" DOUBLE PRECISION NOT NULL DEFAULT 7;

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "ai_managed_workouts_life_cycle" INTEGER NOT NULL DEFAULT 12;
