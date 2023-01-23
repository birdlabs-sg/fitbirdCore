/*
  Warnings:

  - Made the column `date_scheduled` on table `Workout` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "Workout" ALTER COLUMN "date_scheduled" SET NOT NULL,
ALTER COLUMN "date_scheduled" SET DATA TYPE TIMESTAMP(3);
