/*
  Warnings:

  - You are about to drop the column `goals` on the `User` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "User" DROP COLUMN "goals",
ADD COLUMN     "goal" "Goal",
ADD COLUMN     "workout_duration" INTEGER;
