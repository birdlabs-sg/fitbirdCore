/*
  Warnings:

  - A unique constraint covering the columns `[base_user_id]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `base_user_id` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- Add base_user_id as a nullable column first
ALTER TABLE "User" ADD COLUMN     "base_user_id" INTEGER;

-- AlterTable
ALTER TABLE "Workout" ADD COLUMN     "programProgram_id" INTEGER;

-- CreateTable
CREATE TABLE "BaseUser" (
    "base_user_id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "firebase_uid" TEXT NOT NULL,
    "displayName" TEXT NOT NULL,

    CONSTRAINT "BaseUser_pkey" PRIMARY KEY ("base_user_id")
);

-- CreateTable
CREATE TABLE "Coach" (
    "coach_id" SERIAL NOT NULL,
    "base_user_id" INTEGER NOT NULL,

    CONSTRAINT "Coach_pkey" PRIMARY KEY ("coach_id")
);

-- CreateTable
CREATE TABLE "Review" (
    "review_id" SERIAL NOT NULL,
    "rating" DOUBLE PRECISION NOT NULL,
    "content" TEXT NOT NULL,
    "coach_id" INTEGER NOT NULL,

    CONSTRAINT "Review_pkey" PRIMARY KEY ("review_id")
);

-- CreateTable
CREATE TABLE "Program" (
    "program_id" SERIAL NOT NULL,
    "coach_id" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,

    CONSTRAINT "Program_pkey" PRIMARY KEY ("program_id")
);

-- Generate the BaseUserTypes based on the current user table
INSERT INTO "BaseUser" ("email","firebase_uid","displayName") (SELECT "email","firebase_uid","displayName" FROM "User");

-- Update the User model to have the correct associations and drop the not needed data
UPDATE "User" AS u
SET base_user_id = bu.base_user_id
FROM "BaseUser" as bu
WHERE bu.email = u.email;

ALTER TABLE "User" ALTER COLUMN "base_user_id" SET NOT NULL;

ALTER TABLE "User"
  DROP COLUMN "firebase_uid", 
  DROP COLUMN "email",
  DROP COLUMN "displayName";


-- CreateIndex
CREATE UNIQUE INDEX "BaseUser_email_key" ON "BaseUser"("email");

-- CreateIndex
CREATE UNIQUE INDEX "BaseUser_firebase_uid_key" ON "BaseUser"("firebase_uid");

-- CreateIndex
CREATE UNIQUE INDEX "Coach_base_user_id_key" ON "Coach"("base_user_id");

-- CreateIndex
CREATE UNIQUE INDEX "User_base_user_id_key" ON "User"("base_user_id");

-- AddForeignKey
ALTER TABLE "Coach" ADD CONSTRAINT "Coach_base_user_id_fkey" FOREIGN KEY ("base_user_id") REFERENCES "BaseUser"("base_user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Review" ADD CONSTRAINT "Review_coach_id_fkey" FOREIGN KEY ("coach_id") REFERENCES "Coach"("coach_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Program" ADD CONSTRAINT "Program_coach_id_fkey" FOREIGN KEY ("coach_id") REFERENCES "Coach"("coach_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Program" ADD CONSTRAINT "Program_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_base_user_id_fkey" FOREIGN KEY ("base_user_id") REFERENCES "BaseUser"("base_user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Workout" ADD CONSTRAINT "Workout_programProgram_id_fkey" FOREIGN KEY ("programProgram_id") REFERENCES "Program"("program_id") ON DELETE SET NULL ON UPDATE CASCADE;
