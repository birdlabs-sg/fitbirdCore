-- AlterTable
ALTER TABLE "Excercise" ADD COLUMN     "userUser_id" INTEGER;

-- CreateTable
CREATE TABLE "_ExcerciseToUser" (
    "A" TEXT NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_ExcerciseToUser_AB_unique" ON "_ExcerciseToUser"("A", "B");

-- CreateIndex
CREATE INDEX "_ExcerciseToUser_B_index" ON "_ExcerciseToUser"("B");

-- AddForeignKey
ALTER TABLE "_ExcerciseToUser" ADD CONSTRAINT "_ExcerciseToUser_A_fkey" FOREIGN KEY ("A") REFERENCES "Excercise"("excercise_name") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ExcerciseToUser" ADD CONSTRAINT "_ExcerciseToUser_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;
