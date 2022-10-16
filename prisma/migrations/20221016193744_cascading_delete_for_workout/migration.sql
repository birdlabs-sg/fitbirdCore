-- DropForeignKey
ALTER TABLE "Workout" DROP CONSTRAINT "Workout_programProgram_id_fkey";

-- AddForeignKey
ALTER TABLE "Workout" ADD CONSTRAINT "Workout_programProgram_id_fkey" FOREIGN KEY ("programProgram_id") REFERENCES "Program"("program_id") ON DELETE CASCADE ON UPDATE CASCADE;
