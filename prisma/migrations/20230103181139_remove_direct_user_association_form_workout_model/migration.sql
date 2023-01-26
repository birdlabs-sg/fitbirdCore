/*
  Warnings:

  - You are about to drop the column `user_id` on the `Workout` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "Workout" DROP CONSTRAINT "Workout_user_id_fkey";

-- AlterTable
ALTER TABLE "Workout" DROP COLUMN "user_id";
