/*
  Warnings:

  - You are about to drop the column `life_span` on the `ProgramPreset` table. All the data in the column will be lost.
  - You are about to drop the column `ai_managed_workouts_life_cycle` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `life_span` on the `Workout` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "ProgramPreset" DROP COLUMN "life_span";

-- AlterTable
ALTER TABLE "User" DROP COLUMN "ai_managed_workouts_life_cycle";

-- AlterTable
ALTER TABLE "Workout" DROP COLUMN "life_span";
