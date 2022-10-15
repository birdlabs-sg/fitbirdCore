/*
  Warnings:

  - You are about to drop the column `rate_of_perceived_exertion` on the `ExcerciseSetGroup` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "ExcerciseSet" ADD COLUMN     "rate_of_perceived_exertion" INTEGER;

-- AlterTable
ALTER TABLE "ExcerciseSetGroup" DROP COLUMN "rate_of_perceived_exertion";
