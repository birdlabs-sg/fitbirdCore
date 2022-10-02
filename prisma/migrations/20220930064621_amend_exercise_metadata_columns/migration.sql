/*
  Warnings:

  - You are about to drop the column `historical_averag_best_rep` on the `ExcerciseMetadata` table. All the data in the column will be lost.
  - You are about to drop the column `historical_best_one_rep_max` on the `ExcerciseMetadata` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "ExcerciseMetadata" DROP COLUMN "historical_averag_best_rep",
DROP COLUMN "historical_best_one_rep_max",
ADD COLUMN     "estimated_historical_average_best_rep" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "estimated_historical_best_one_rep_max" DOUBLE PRECISION NOT NULL DEFAULT 0;
