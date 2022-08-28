-- DropForeignKey
ALTER TABLE "ExcerciseSetGroup" DROP CONSTRAINT "ExcerciseSetGroup_excercise_name_fkey";

-- AddForeignKey
ALTER TABLE "ExcerciseSetGroup" ADD CONSTRAINT "ExcerciseSetGroup_excercise_name_fkey" FOREIGN KEY ("excercise_name") REFERENCES "Excercise"("excercise_name") ON DELETE CASCADE ON UPDATE CASCADE;
