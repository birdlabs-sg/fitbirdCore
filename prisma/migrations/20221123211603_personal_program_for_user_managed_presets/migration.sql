-- AlterTable
ALTER TABLE "Workout" ADD COLUMN     "personalprogramProgram_id" INTEGER;

-- CreateTable
CREATE TABLE "PersonalProgram" (
    "personalProgram_id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "PersonalProgram_pkey" PRIMARY KEY ("personalProgram_id")
);

-- AddForeignKey
ALTER TABLE "PersonalProgram" ADD CONSTRAINT "PersonalProgram_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Workout" ADD CONSTRAINT "Workout_personalprogramProgram_id_fkey" FOREIGN KEY ("personalprogramProgram_id") REFERENCES "PersonalProgram"("personalProgram_id") ON DELETE CASCADE ON UPDATE CASCADE;
