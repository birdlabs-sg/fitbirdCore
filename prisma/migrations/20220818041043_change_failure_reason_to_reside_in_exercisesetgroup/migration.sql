/*
  Warnings:

  - You are about to drop the column `failure_reason` on the `ExcerciseSet` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "ExcerciseSet" DROP COLUMN "failure_reason";

-- AlterTable
ALTER TABLE "ExcerciseSetGroup" ADD COLUMN     "failure_reason" "FailureReason";
