/*
  Warnings:

  - You are about to drop the `Challenge` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `ChallengePreset` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `PresetExcerciseSet` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `PresetExcerciseSetGroup` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `PresetWorkouts` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Challenge" DROP CONSTRAINT "Challenge_presetPreset_id_fkey";

-- DropForeignKey
ALTER TABLE "Challenge" DROP CONSTRAINT "Challenge_user_id_fkey";

-- DropForeignKey
ALTER TABLE "PresetExcerciseSet" DROP CONSTRAINT "PresetExcerciseSet_preset_excercise_set_group_id_fkey";

-- DropForeignKey
ALTER TABLE "PresetExcerciseSetGroup" DROP CONSTRAINT "PresetExcerciseSetGroup_excercise_name_fkey";

-- DropForeignKey
ALTER TABLE "PresetExcerciseSetGroup" DROP CONSTRAINT "PresetExcerciseSetGroup_preset_workout_id_fkey";

-- DropForeignKey
ALTER TABLE "PresetWorkouts" DROP CONSTRAINT "PresetWorkouts_challengePreset_id_fkey";

-- DropForeignKey
ALTER TABLE "Workout" DROP CONSTRAINT "Workout_challengeChallenge_id_fkey";

-- DropTable
DROP TABLE "Challenge";

-- DropTable
DROP TABLE "ChallengePreset";

-- DropTable
DROP TABLE "PresetExcerciseSet";

-- DropTable
DROP TABLE "PresetExcerciseSetGroup";

-- DropTable
DROP TABLE "PresetWorkouts";
