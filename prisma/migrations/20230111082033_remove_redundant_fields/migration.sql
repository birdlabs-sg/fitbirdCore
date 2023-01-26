/*
  Warnings:

  - You are about to drop the column `weight_unit` on the `ExcerciseMetadata` table. All the data in the column will be lost.
  - You are about to drop the column `weight_unit` on the `ExcerciseSet` table. All the data in the column will be lost.
  - You are about to drop the column `weight_unit` on the `PresetExcerciseSet` table. All the data in the column will be lost.
  - You are about to drop the column `phoneNumber` on the `User` table. All the data in the column will be lost.
  - Made the column `gender` on table `User` required. This step will fail if there are existing NULL values in that column.
  - Made the column `weight_unit` on table `User` required. This step will fail if there are existing NULL values in that column.
  - Made the column `height_unit` on table `User` required. This step will fail if there are existing NULL values in that column.

*/
BEGIN;
-- AlterTable
ALTER TABLE "BaseUser" ADD COLUMN     "phoneNumber" TEXT;

-- AlterTable
ALTER TABLE "ExcerciseMetadata" DROP COLUMN "weight_unit";

-- AlterTable
ALTER TABLE "ExcerciseSet" DROP COLUMN "weight_unit";

-- AlterTable
ALTER TABLE "PresetExcerciseSet" DROP COLUMN "weight_unit";

-- AlterTable
ALTER TABLE "User" DROP COLUMN "phoneNumber";

UPDATE "User" SET "gender" = 'MALE' WHERE "gender" IS NULL;
ALTER TABLE "User" ALTER COLUMN "gender" SET NOT NULL;
ALTER TABLE "User" ALTER COLUMN "gender" SET DEFAULT 'MALE';

UPDATE "User" SET "weight_unit" = 'KG' WHERE "weight_unit" IS NULL;
ALTER TABLE "User" ALTER COLUMN "weight_unit" SET NOT NULL;
ALTER TABLE "User" ALTER COLUMN "weight_unit" SET DEFAULT 'KG';

UPDATE "User" SET "height_unit" = 'CM' WHERE "height_unit" IS NULL;
ALTER TABLE "User" ALTER COLUMN "height_unit" SET NOT NULL;
ALTER TABLE "User" ALTER COLUMN "height_unit" SET DEFAULT 'CM';
COMMIT;
