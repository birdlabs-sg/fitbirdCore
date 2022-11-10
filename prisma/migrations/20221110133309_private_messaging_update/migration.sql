/*
  Warnings:

  - Added the required column `message_content` to the `PrivateMessage` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "PrivateMessage" ADD COLUMN     "message_content" TEXT NOT NULL;
