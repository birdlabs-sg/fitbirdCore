-- DropForeignKey
ALTER TABLE "ExcerciseSetGroup" DROP CONSTRAINT "ExcerciseSetGroup_workout_id_fkey";

-- AddForeignKey
ALTER TABLE "ExcerciseSetGroup" ADD CONSTRAINT "ExcerciseSetGroup_workout_id_fkey" FOREIGN KEY ("workout_id") REFERENCES "Workout"("workout_id") ON DELETE CASCADE ON UPDATE CASCADE;
