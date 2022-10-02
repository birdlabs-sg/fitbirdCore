-- AlterTable
ALTER TABLE "ExcerciseMetadata" ADD COLUMN     "historical_averag_best_rep" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "historical_best_one_rep_max" DOUBLE PRECISION NOT NULL DEFAULT 0;
