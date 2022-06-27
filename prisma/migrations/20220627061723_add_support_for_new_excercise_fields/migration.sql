/*
  Warnings:

  - You are about to drop the `_stabilizers` table. If the table is not empty, all the data it contains will be lost.

*/
-- CreateEnum
CREATE TYPE "ExcerciseMechanics" AS ENUM ('COMPOUND', 'ISOLATED');

-- CreateEnum
CREATE TYPE "ExcerciseForce" AS ENUM ('PUSH', 'PULL');

-- CreateEnum
CREATE TYPE "ExcerciseUtility" AS ENUM ('BASIC', 'AUXILIARY');

-- DropForeignKey
ALTER TABLE "_stabilizers" DROP CONSTRAINT "_stabilizers_A_fkey";

-- DropForeignKey
ALTER TABLE "_stabilizers" DROP CONSTRAINT "_stabilizers_B_fkey";

-- AlterTable
ALTER TABLE "Excercise" ADD COLUMN     "excercise_force" "ExcerciseForce"[],
ADD COLUMN     "excercise_mechanics" "ExcerciseMechanics"[],
ADD COLUMN     "excercise_utility" "ExcerciseUtility"[];

-- AlterTable
ALTER TABLE "MuscleRegion" ALTER COLUMN "muscle_region_description" DROP NOT NULL;

-- DropTable
DROP TABLE "_stabilizers";

-- CreateTable
CREATE TABLE "_stabilizer" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_synergist" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_dynamic" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_stabilizer_AB_unique" ON "_stabilizer"("A", "B");

-- CreateIndex
CREATE INDEX "_stabilizer_B_index" ON "_stabilizer"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_synergist_AB_unique" ON "_synergist"("A", "B");

-- CreateIndex
CREATE INDEX "_synergist_B_index" ON "_synergist"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_dynamic_AB_unique" ON "_dynamic"("A", "B");

-- CreateIndex
CREATE INDEX "_dynamic_B_index" ON "_dynamic"("B");

-- AddForeignKey
ALTER TABLE "_stabilizer" ADD CONSTRAINT "_stabilizer_A_fkey" FOREIGN KEY ("A") REFERENCES "Excercise"("excercise_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_stabilizer" ADD CONSTRAINT "_stabilizer_B_fkey" FOREIGN KEY ("B") REFERENCES "MuscleRegion"("muscle_region_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_synergist" ADD CONSTRAINT "_synergist_A_fkey" FOREIGN KEY ("A") REFERENCES "Excercise"("excercise_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_synergist" ADD CONSTRAINT "_synergist_B_fkey" FOREIGN KEY ("B") REFERENCES "MuscleRegion"("muscle_region_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_dynamic" ADD CONSTRAINT "_dynamic_A_fkey" FOREIGN KEY ("A") REFERENCES "Excercise"("excercise_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_dynamic" ADD CONSTRAINT "_dynamic_B_fkey" FOREIGN KEY ("B") REFERENCES "MuscleRegion"("muscle_region_id") ON DELETE CASCADE ON UPDATE CASCADE;
