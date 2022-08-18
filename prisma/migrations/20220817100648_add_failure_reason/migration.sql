-- CreateEnum
CREATE TYPE "FailureReason" AS ENUM ('INSUFFICIENT_TIME', 'INSUFFICIENT_REST_TIME', 'TOO_DIFFICULT', 'LOW_MOOD', 'INSUFFICIENT_SLEEP');

-- AlterTable
ALTER TABLE "ExcerciseSet" ADD COLUMN     "failure_reason" "FailureReason";
