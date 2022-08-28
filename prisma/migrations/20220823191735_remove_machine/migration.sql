/*
  Warnings:

  - The values [MACHINE] on the enum `Equipment` will be removed. If these variants are still used in the database, this will fail.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "Equipment_new" AS ENUM ('DUMBBELL', 'BARBELL', 'KETTLEBELL', 'CABLE', 'LEVER', 'SUSPENSION', 'T_BAR', 'TRAP_BAR', 'SLED', 'SMITH', 'BENCH', 'MEDICINE_BALL', 'PREACHER', 'PARALLEL_BARS', 'PULL_UP_BAR', 'STABILITY_BALL');
ALTER TABLE "User" ALTER COLUMN "equipment_accessible" TYPE "Equipment_new"[] USING ("equipment_accessible"::text::"Equipment_new"[]);
ALTER TABLE "Excercise" ALTER COLUMN "equipment_required" TYPE "Equipment_new"[] USING ("equipment_required"::text::"Equipment_new"[]);
ALTER TYPE "Equipment" RENAME TO "Equipment_old";
ALTER TYPE "Equipment_new" RENAME TO "Equipment";
DROP TYPE "Equipment_old";
COMMIT;
