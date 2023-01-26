/*
  Warnings:

  - Added the required column `active` to the `CoachClientRelationship` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "CoachClientRelationship" ADD COLUMN     "active" BOOLEAN NOT NULL;
