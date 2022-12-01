-- AddForeignKey
ALTER TABLE "PresetExcerciseSetGroup" ADD CONSTRAINT "PresetExcerciseSetGroup_excercise_name_fkey" FOREIGN KEY ("excercise_name") REFERENCES "Excercise"("excercise_name") ON DELETE CASCADE ON UPDATE CASCADE;
