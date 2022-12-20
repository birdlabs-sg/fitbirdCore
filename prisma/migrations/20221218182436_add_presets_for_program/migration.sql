-- AlterTable
ALTER TABLE "Program" ADD COLUMN     "program_preset_id" INTEGER;

-- CreateTable
CREATE TABLE "ProgramPreset" (
    "programPreset_id" SERIAL NOT NULL,
    "preset_name" TEXT NOT NULL,
    "life_span" INTEGER NOT NULL,
    "preset_difficulty" "PresetDifficulty" NOT NULL,
    "image_url" TEXT,
    "coach_id" INTEGER NOT NULL,

    CONSTRAINT "ProgramPreset_pkey" PRIMARY KEY ("programPreset_id")
);

-- CreateTable
CREATE TABLE "PresetWorkouts" (
    "preset_workout_id" SERIAL NOT NULL,
    "programPreset_id" INTEGER NOT NULL,
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
    "weight_unit" "WeightUnit" NOT NULL DEFAULT 'KG',

    CONSTRAINT "PresetExcerciseSet_pkey" PRIMARY KEY ("preset_excercise_set_id")
);

-- AddForeignKey
ALTER TABLE "ProgramPreset" ADD CONSTRAINT "ProgramPreset_coach_id_fkey" FOREIGN KEY ("coach_id") REFERENCES "Coach"("coach_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PresetWorkouts" ADD CONSTRAINT "PresetWorkouts_programPreset_id_fkey" FOREIGN KEY ("programPreset_id") REFERENCES "ProgramPreset"("programPreset_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PresetExcerciseSetGroup" ADD CONSTRAINT "PresetExcerciseSetGroup_preset_workout_id_fkey" FOREIGN KEY ("preset_workout_id") REFERENCES "PresetWorkouts"("preset_workout_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PresetExcerciseSetGroup" ADD CONSTRAINT "PresetExcerciseSetGroup_excercise_name_fkey" FOREIGN KEY ("excercise_name") REFERENCES "Excercise"("excercise_name") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PresetExcerciseSet" ADD CONSTRAINT "PresetExcerciseSet_preset_excercise_set_group_id_fkey" FOREIGN KEY ("preset_excercise_set_group_id") REFERENCES "PresetExcerciseSetGroup"("preset_excercise_set_group_id") ON DELETE CASCADE ON UPDATE CASCADE;
