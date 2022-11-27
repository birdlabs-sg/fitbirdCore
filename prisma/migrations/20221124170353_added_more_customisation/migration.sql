/*
  Warnings:

  - Added the required column `duration` to the `ChallengePreset` table without a default value. This is not possible if the table is not empty.
  - Added the required column `preset_difficulty` to the `ChallengePreset` table without a default value. This is not possible if the table is not empty.
  - Added the required column `preset_name` to the `ChallengePreset` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "PresetDifficulty" AS ENUM ('EASY', 'NORMAL', 'HARD', 'VERY_HARD');

-- AlterTable
ALTER TABLE "ChallengePreset" ADD COLUMN     "duration" INTEGER NOT NULL,
ADD COLUMN     "image_url" TEXT,
ADD COLUMN     "preset_difficulty" "PresetDifficulty" NOT NULL,
ADD COLUMN     "preset_name" TEXT NOT NULL;
