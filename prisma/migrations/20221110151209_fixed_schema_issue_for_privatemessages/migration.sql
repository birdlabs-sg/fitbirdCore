/*
  Warnings:

  - The primary key for the `PrivateMessage` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `message_id` column on the `PrivateMessage` table would be dropped and recreated. This will lead to data loss if there is data in the column.

*/
-- AlterTable
ALTER TABLE "PrivateMessage" DROP CONSTRAINT "PrivateMessage_pkey",
DROP COLUMN "message_id",
ADD COLUMN     "message_id" SERIAL NOT NULL,
ADD CONSTRAINT "PrivateMessage_pkey" PRIMARY KEY ("message_id");
