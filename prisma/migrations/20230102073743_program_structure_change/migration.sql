/*
  Warnings:

  - The values [DRAFT] on the enum `WorkoutState` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the column `workout_type_enrollment` on the `User` table. All the data in the column will be lost.
  - You are about to rename the column `date_completed` on the `Workout` table to 'date_closed'.
  - You are about to drop the column `order_index` on the `Workout` table. All the data in the column will be lost.
  - You are about to drop the column `workout_type` on the `Workout` table. All the data in the column will be lost.
  - Added the required column `current_program_enrollment_id` to the `User` table without a default value. This is not possible if the table is not empty.
  - Added the required column `dayOfWeek` to the `Workout` table without a default value. This is not possible if the table is not empty.
  - Made the column `programProgram_id` on table `Workout` required. This step will fail if there are existing NULL values in that column.

*/

-- CreateEnum
CREATE TYPE "DayOfWeek" AS ENUM ('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY');

-- CreateEnum
CREATE TYPE "ProgramType" AS ENUM ('AI_MANAGED', 'SELF_MANAGED', 'COACH_MANAGED');

-- AlterEnum
BEGIN;
CREATE TYPE "WorkoutState_new" AS ENUM ('UNATTEMPTED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED');
ALTER TABLE "Workout" ALTER COLUMN "workout_state" DROP DEFAULT;
ALTER TABLE "Workout" ALTER COLUMN "workout_state" TYPE "WorkoutState_new" USING ("workout_state"::text::"WorkoutState_new");
ALTER TYPE "WorkoutState" RENAME TO "WorkoutState_old";
ALTER TYPE "WorkoutState_new" RENAME TO "WorkoutState";
DROP TYPE "WorkoutState_old";
ALTER TABLE "Workout" ALTER COLUMN "workout_state" SET DEFAULT 'UNATTEMPTED';
COMMIT;

ALTER TABLE "Program" ALTER COLUMN "coach_id" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Program" ADD COLUMN     "ending_date" TIMESTAMP(3),
ADD COLUMN     "program_type" "ProgramType" NOT NULL DEFAULT E'SELF_MANAGED',
ADD COLUMN     "starting_date" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "User" DROP COLUMN "workout_type_enrollment",
ADD COLUMN     "current_program_enrollment_id" INTEGER,
ADD COLUMN     "signup_date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- Maps the order_index to dayOfWeek enum
ALTER TABLE "Workout" ADD COLUMN "dayOfWeek" "DayOfWeek";

-- migrate all workouts without a program to a program.
do
$$
declare
  rec_var1 record;
declare
  rec_var2 record;
declare
  rec_var3 record;
declare 
  selfMangedProgram_id INTEGER;
declare
  aiMangedProgram INTEGER;
begin
raise notice 'hey';
FOR rec_var1 IN (SELECT order_index,workout_id FROM "Workout") LOOP
   -- Create a self-program and a ai-managed program
  raise notice 'Value: %', rec_var1;
  IF rec_var1.order_index = 0
  THEN
    UPDATE "Workout" set "dayOfWeek" = 'MONDAY' where "workout_id" = rec_var1.workout_id;
  ELSEIF rec_var1.order_index = 1 
  THEN
    UPDATE "Workout" set "dayOfWeek" = 'TUESDAY' where "workout_id" = rec_var1.workout_id;
  ELSEIF rec_var1.order_index = 2 
  THEN
    UPDATE "Workout" set "dayOfWeek" = 'WEDNESDAY' where "workout_id" = rec_var1.workout_id;
  ELSEIF rec_var1.order_index = 3 
  THEN
    UPDATE "Workout" set "dayOfWeek" = 'THURSDAY' where "workout_id" = rec_var1.workout_id;
  ELSEIF rec_var1.order_index = 4 
  THEN
    UPDATE "Workout" set "dayOfWeek" = 'FRIDAY' where "workout_id" = rec_var1.workout_id;
  ELSEIF rec_var1.order_index = 5 
  THEN
    UPDATE "Workout" set "dayOfWeek" = 'SATURDAY'  where "workout_id" = rec_var1.workout_id;
  ELSEIF rec_var1.order_index = 6
  THEN
    UPDATE "Workout" set "dayOfWeek" = 'SUNDAY' where "workout_id" = rec_var1.workout_id;
  ELSE
    DELETE FROM "Workout" WHERE  workout_id = rec_var1.workout_id;
  END IF;
END LOOP;

FOR rec_var2 IN (SELECT user_id FROM "User") LOOP
   -- Create a self-program and a ai-managed program
  INSERT INTO "Program" (program_type, starting_date,user_id)  VALUES ('SELF_MANAGED', now()::timestamp, rec_var2.user_id);
  INSERT INTO "Program" (program_type, starting_date,user_id)  VALUES ('AI_MANAGED', now()::timestamp, rec_var2.user_id);
END LOOP;

FOR rec_var3 IN (SELECT workout_id,workout_type,user_id FROM "Workout") LOOP
   -- Assign the workout to the "self-program" or "ai-managed" program
  IF rec_var3.workout_type = 'SELF_MANAGED'::"WorkoutType"
  THEN
    selfMangedProgram_id = (select "program_id" from "Program" where program_type = 'SELF_MANAGED'::"ProgramType"  and user_id= rec_var3.user_id LIMIT 1);
    UPDATE "Workout" set "programProgram_id" = selfMangedProgram_id where workout_id = rec_var3.workout_id;
  ELSEIF rec_var3.workout_type = 'AI_MANAGED'::"WorkoutType"
  THEN
    aiMangedProgram = (select "program_id" from "Program" where program_type = 'AI_MANAGED'::"ProgramType" and user_id= rec_var3.user_id LIMIT 1);
    UPDATE "Workout" set "programProgram_id" = aiMangedProgram where workout_id = rec_var3.workout_id;
  ELSE
    DELETE FROM "Workout" WHERE  workout_id = rec_var3.workout_id;
  END IF;
END LOOP;
end;
$$;

-- AlterTable
ALTER TABLE "Workout"
  RENAME COLUMN "date_completed" TO "date_closed";
ALTER TABLE "Workout"
  DROP COLUMN "order_index",
  DROP COLUMN "workout_type",
  ALTER COLUMN "dayOfWeek" SET NOT NULL,
  ALTER COLUMN "programProgram_id" SET NOT NULL;

ALTER TABLE "Program" ALTER COLUMN "starting_date" SET NOT NULL;

-- DropEnum
DROP TYPE "WorkoutType";