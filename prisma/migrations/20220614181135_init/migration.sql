-- CreateEnum
CREATE TYPE "Gender" AS ENUM ('CIS_MALE', 'CIS_FEMALE', 'RATHER_NOT_SAY');

-- CreateEnum
CREATE TYPE "LengthUnit" AS ENUM ('CM', 'MM', 'MTR', 'FT');

-- CreateEnum
CREATE TYPE "WeightUnit" AS ENUM ('KG', 'LB');

-- CreateEnum
CREATE TYPE "Goal" AS ENUM ('LOSE_WEIGHT', 'KEEP_FIT', 'BUILD_MUSCLE', 'INCREASE_ATHLETICISM');

-- CreateTable
CREATE TABLE "User" (
    "user_id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "firebase_uid" TEXT NOT NULL,
    "displayName" TEXT NOT NULL,
    "prior_years_of_experience" TEXT,
    "self_schedule" BOOLEAN,
    "frequency_workouts" INTEGER,
    "goals" "Goal",
    "gender" "Gender",
    "weight" DOUBLE PRECISION,
    "height" DOUBLE PRECISION,
    "weight_unit" "WeightUnit",
    "height_unit" "LengthUnit",
    "phoneNumber" TEXT,

    CONSTRAINT "User_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "ExcerciseRestTimeRange" (
    "rest_time_lower_bound" INTEGER NOT NULL,
    "rest_time_upper_bound" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,
    "excercise_id" INTEGER NOT NULL,

    CONSTRAINT "ExcerciseRestTimeRange_pkey" PRIMARY KEY ("user_id","excercise_id")
);

-- CreateTable
CREATE TABLE "Measurement" (
    "measurement_id" SERIAL NOT NULL,
    "measured_at" TIMESTAMP(3) NOT NULL,
    "measurement_value" DOUBLE PRECISION NOT NULL,
    "length_units" "LengthUnit" NOT NULL,
    "user_id" INTEGER NOT NULL,
    "muscle_region_id" INTEGER NOT NULL,

    CONSTRAINT "Measurement_pkey" PRIMARY KEY ("measurement_id")
);

-- CreateTable
CREATE TABLE "Workout" (
    "workout_id" SERIAL NOT NULL,
    "repetition_count_left" INTEGER NOT NULL,
    "date_scheduled" TIMESTAMP(3),
    "date_completed" TIMESTAMP(3),
    "performance_rating" DOUBLE PRECISION,
    "user_id" INTEGER NOT NULL,

    CONSTRAINT "Workout_pkey" PRIMARY KEY ("workout_id")
);

-- CreateTable
CREATE TABLE "MuscleRegion" (
    "muscle_region_id" SERIAL NOT NULL,
    "muscle_region_name" TEXT NOT NULL,
    "muscle_region_description" TEXT NOT NULL,

    CONSTRAINT "MuscleRegion_pkey" PRIMARY KEY ("muscle_region_id")
);

-- CreateTable
CREATE TABLE "Excercise" (
    "excercise_id" SERIAL NOT NULL,
    "excercise_name" TEXT NOT NULL,
    "excercise_description" TEXT,
    "excercise_instructions" TEXT,
    "excercise_tips" TEXT,

    CONSTRAINT "Excercise_pkey" PRIMARY KEY ("excercise_id")
);

-- CreateTable
CREATE TABLE "ExcerciseSet" (
    "excercise_set_id" SERIAL NOT NULL,
    "workout_id" INTEGER NOT NULL,
    "excercise_id" INTEGER NOT NULL,
    "weight" DOUBLE PRECISION NOT NULL,
    "weight_unit" "WeightUnit" NOT NULL,
    "target_reps" INTEGER NOT NULL,
    "actual_reps" INTEGER,
    "actual_weight" DOUBLE PRECISION,
    "actual_weight_unit" INTEGER,

    CONSTRAINT "ExcerciseSet_pkey" PRIMARY KEY ("excercise_set_id")
);

-- CreateTable
CREATE TABLE "BroadCast" (
    "broad_cast_id" SERIAL NOT NULL,
    "broadcast_message" TEXT NOT NULL,
    "scheduled_start" TIMESTAMP(3) NOT NULL,
    "scheduled_end" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BroadCast_pkey" PRIMARY KEY ("broad_cast_id")
);

-- CreateTable
CREATE TABLE "Notification" (
    "notification_id" SERIAL NOT NULL,
    "notification_message" TEXT NOT NULL,
    "user_id" INTEGER NOT NULL,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("notification_id")
);

-- CreateTable
CREATE TABLE "_target" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_stabilizers" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_BroadCastToUser" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "User_firebase_uid_key" ON "User"("firebase_uid");

-- CreateIndex
CREATE UNIQUE INDEX "_target_AB_unique" ON "_target"("A", "B");

-- CreateIndex
CREATE INDEX "_target_B_index" ON "_target"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_stabilizers_AB_unique" ON "_stabilizers"("A", "B");

-- CreateIndex
CREATE INDEX "_stabilizers_B_index" ON "_stabilizers"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_BroadCastToUser_AB_unique" ON "_BroadCastToUser"("A", "B");

-- CreateIndex
CREATE INDEX "_BroadCastToUser_B_index" ON "_BroadCastToUser"("B");

-- AddForeignKey
ALTER TABLE "ExcerciseRestTimeRange" ADD CONSTRAINT "ExcerciseRestTimeRange_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ExcerciseRestTimeRange" ADD CONSTRAINT "ExcerciseRestTimeRange_excercise_id_fkey" FOREIGN KEY ("excercise_id") REFERENCES "Excercise"("excercise_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Measurement" ADD CONSTRAINT "Measurement_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Measurement" ADD CONSTRAINT "Measurement_muscle_region_id_fkey" FOREIGN KEY ("muscle_region_id") REFERENCES "MuscleRegion"("muscle_region_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Workout" ADD CONSTRAINT "Workout_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ExcerciseSet" ADD CONSTRAINT "ExcerciseSet_workout_id_fkey" FOREIGN KEY ("workout_id") REFERENCES "Workout"("workout_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ExcerciseSet" ADD CONSTRAINT "ExcerciseSet_excercise_id_fkey" FOREIGN KEY ("excercise_id") REFERENCES "Excercise"("excercise_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_target" ADD CONSTRAINT "_target_A_fkey" FOREIGN KEY ("A") REFERENCES "Excercise"("excercise_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_target" ADD CONSTRAINT "_target_B_fkey" FOREIGN KEY ("B") REFERENCES "MuscleRegion"("muscle_region_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_stabilizers" ADD CONSTRAINT "_stabilizers_A_fkey" FOREIGN KEY ("A") REFERENCES "Excercise"("excercise_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_stabilizers" ADD CONSTRAINT "_stabilizers_B_fkey" FOREIGN KEY ("B") REFERENCES "MuscleRegion"("muscle_region_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BroadCastToUser" ADD CONSTRAINT "_BroadCastToUser_A_fkey" FOREIGN KEY ("A") REFERENCES "BroadCast"("broad_cast_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BroadCastToUser" ADD CONSTRAINT "_BroadCastToUser_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;
