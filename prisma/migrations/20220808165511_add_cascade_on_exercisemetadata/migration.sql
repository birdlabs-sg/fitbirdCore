-- DropForeignKey
ALTER TABLE "ExcerciseMetadata" DROP CONSTRAINT "ExcerciseMetadata_excercise_name_fkey";

-- AddForeignKey
ALTER TABLE "ExcerciseMetadata" ADD CONSTRAINT "ExcerciseMetadata_excercise_name_fkey" FOREIGN KEY ("excercise_name") REFERENCES "Excercise"("excercise_name") ON DELETE CASCADE ON UPDATE CASCADE;
