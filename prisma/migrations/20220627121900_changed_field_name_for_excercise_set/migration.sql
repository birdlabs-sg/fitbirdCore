/*
  Warnings:

  - You are about to drop the column `weight` on the `ExcerciseSet` table. All the data in the column will be lost.
  - You are about to drop the column `weight_unit` on the `ExcerciseSet` table. All the data in the column will be lost.
  - The `actual_weight_unit` column on the `ExcerciseSet` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - Added the required column `target_weight` to the `ExcerciseSet` table without a default value. This is not possible if the table is not empty.
  - Added the required column `target_weight_unit` to the `ExcerciseSet` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "ExcerciseSet" DROP COLUMN "weight",
DROP COLUMN "weight_unit",
ADD COLUMN     "target_weight" DOUBLE PRECISION NOT NULL,
ADD COLUMN     "target_weight_unit" "WeightUnit" NOT NULL,
DROP COLUMN "actual_weight_unit",
ADD COLUMN     "actual_weight_unit" "WeightUnit";
