-- CreateTable
CREATE TABLE "CoachClientRelationship" (
    "coach_id" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,
    "date_created" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CoachClientRelationship_pkey" PRIMARY KEY ("coach_id","user_id")
);

-- AddForeignKey
ALTER TABLE "CoachClientRelationship" ADD CONSTRAINT "CoachClientRelationship_coach_id_fkey" FOREIGN KEY ("coach_id") REFERENCES "Coach"("coach_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CoachClientRelationship" ADD CONSTRAINT "CoachClientRelationship_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;
