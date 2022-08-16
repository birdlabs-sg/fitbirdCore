-- DropForeignKey
ALTER TABLE "ExcerciseMetadata" DROP CONSTRAINT "ExcerciseMetadata_user_id_fkey";

-- AddForeignKey
ALTER TABLE "ExcerciseMetadata" ADD CONSTRAINT "ExcerciseMetadata_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;
