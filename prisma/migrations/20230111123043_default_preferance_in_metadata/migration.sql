/*
  Warnings:

  - You are about to drop the column `haveRequiredEquipment` on the `ExcerciseMetadata` table. All the data in the column will be lost.
  - Made the column `preferred` on table `ExcerciseMetadata` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
BEGIN;
UPDATE "ExcerciseMetadata" SET "preferred" = 'false' WHERE "preferred" IS NULL;
ALTER TABLE "ExcerciseMetadata" ALTER COLUMN "preferred" SET NOT NULL;
ALTER TABLE "ExcerciseMetadata" ALTER COLUMN "preferred" SET DEFAULT 'false';
COMMIT;
