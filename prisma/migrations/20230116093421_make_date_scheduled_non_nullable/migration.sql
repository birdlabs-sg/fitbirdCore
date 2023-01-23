/*
  Warnings:

  - You are about to drop the column `dayOfWeek` on the `Workout` table. All the data in the column will be lost.
  - Made the column `date_scheduled` on table `Workout` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
BEGIN;
ALTER TABLE "Workout" ADD COLUMN "temp_date_scheduled" TIMESTAMP;

UPDATE "Workout" SET "temp_date_scheduled" = "date_closed" WHERE "date_closed" IS NOT NULL;



UPDATE "Workout" SET "temp_date_scheduled" = (CASE "dayOfWeek" 
                                                WHEN 'MONDAY' THEN (date_trunc('week', now()) + '1 day'::interval) 
                                                WHEN 'TUESDAY' THEN (date_trunc('week', now()) + '2 day'::interval) 
                                                WHEN 'WEDNESDAY' THEN (date_trunc('week', now()) + '3 day'::interval) 
                                                WHEN 'THURSDAY' THEN (date_trunc('week', now()) + '4 day'::interval) 
                                                WHEN 'FRIDAY' THEN (date_trunc('week', now()) + '5 day'::interval) 
                                                WHEN 'SATURDAY' THEN (date_trunc('week', now()) + '6 day'::interval) 
                                                WHEN 'SUNDAY' THEN (date_trunc('week', now()) + '7 day'::interval) 
                                                ELSE "temp_date_scheduled" END) 

WHERE "temp_date_scheduled" IS NULL;

ALTER TABLE "Workout" DROP COLUMN "date_scheduled";

ALTER TABLE "Workout" RENAME COLUMN "temp_date_scheduled" TO "date_scheduled";



ALTER TABLE "Workout" DROP COLUMN "dayOfWeek";
COMMIT;