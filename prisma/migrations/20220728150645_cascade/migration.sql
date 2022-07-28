-- DropForeignKey
ALTER TABLE "ExcerciseSet" DROP CONSTRAINT "ExcerciseSet_excercise_set_group_id_fkey";

-- AddForeignKey
ALTER TABLE "ExcerciseSet" ADD CONSTRAINT "ExcerciseSet_excercise_set_group_id_fkey" FOREIGN KEY ("excercise_set_group_id") REFERENCES "ExcerciseSetGroup"("excercise_set_group_id") ON DELETE CASCADE ON UPDATE CASCADE;
