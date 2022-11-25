/*
  Warnings:

  - You are about to drop the column `personalprogramProgram_id` on the `Workout` table. All the data in the column will be lost.
  - You are about to drop the `PersonalProgram` table. If the table is not empty, all the data it contains will be lost.

*/
-- AlterEnum
ALTER TYPE "WorkoutType" ADD VALUE 'CHALLENGE';

-- DropForeignKey
ALTER TABLE "PersonalProgram" DROP CONSTRAINT "PersonalProgram_user_id_fkey";

-- DropForeignKey
ALTER TABLE "Workout" DROP CONSTRAINT "Workout_personalprogramProgram_id_fkey";

-- AlterTable
ALTER TABLE "Workout" DROP COLUMN "personalprogramProgram_id",
ADD COLUMN     "challengeChallenge_id" INTEGER;

-- DropTable
DROP TABLE "PersonalProgram";

-- CreateTable
CREATE TABLE "Challenge" (
    "challenge_id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Challenge_pkey" PRIMARY KEY ("challenge_id")
);

-- AddForeignKey
ALTER TABLE "Challenge" ADD CONSTRAINT "Challenge_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Workout" ADD CONSTRAINT "Workout_challengeChallenge_id_fkey" FOREIGN KEY ("challengeChallenge_id") REFERENCES "Challenge"("challenge_id") ON DELETE CASCADE ON UPDATE CASCADE;
