/*
  Warnings:

  - Added the required column `presetPreset_id` to the `Challenge` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Challenge" ADD COLUMN     "completion_date" TIMESTAMP(3),
ADD COLUMN     "completion_status" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "presetPreset_id" INTEGER NOT NULL;

-- CreateTable
CREATE TABLE "ChallengePreset" (
    "challengePreset_id" SERIAL NOT NULL,

    CONSTRAINT "ChallengePreset_pkey" PRIMARY KEY ("challengePreset_id")
);

-- CreateTable
CREATE TABLE "PresetWorkouts" (
    "preset_workout_id" SERIAL NOT NULL,
    "challengePreset_id" INTEGER NOT NULL,
    "rest_day" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "PresetWorkouts_pkey" PRIMARY KEY ("preset_workout_id")
);

-- CreateTable
CREATE TABLE "PresetExcerciseSetGroup" (
    "preset_excercise_set_group_id" SERIAL NOT NULL,
    "preset_workout_id" INTEGER NOT NULL,
    "excercise_name" TEXT NOT NULL,

    CONSTRAINT "PresetExcerciseSetGroup_pkey" PRIMARY KEY ("preset_excercise_set_group_id")
);

-- CreateTable
CREATE TABLE "PresetExcerciseSet" (
    "preset_excercise_set_id" SERIAL NOT NULL,
    "preset_excercise_set_group_id" INTEGER NOT NULL,
    "target_reps" INTEGER NOT NULL,
    "target_weight" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "PresetExcerciseSet_pkey" PRIMARY KEY ("preset_excercise_set_id")
);

-- AddForeignKey
ALTER TABLE "Challenge" ADD CONSTRAINT "Challenge_presetPreset_id_fkey" FOREIGN KEY ("presetPreset_id") REFERENCES "ChallengePreset"("challengePreset_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PresetWorkouts" ADD CONSTRAINT "PresetWorkouts_challengePreset_id_fkey" FOREIGN KEY ("challengePreset_id") REFERENCES "ChallengePreset"("challengePreset_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PresetExcerciseSetGroup" ADD CONSTRAINT "PresetExcerciseSetGroup_preset_workout_id_fkey" FOREIGN KEY ("preset_workout_id") REFERENCES "PresetWorkouts"("preset_workout_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PresetExcerciseSet" ADD CONSTRAINT "PresetExcerciseSet_preset_excercise_set_group_id_fkey" FOREIGN KEY ("preset_excercise_set_group_id") REFERENCES "PresetExcerciseSetGroup"("preset_excercise_set_group_id") ON DELETE CASCADE ON UPDATE CASCADE;
