-- CreateEnum
CREATE TYPE "Gender" AS ENUM ('MALE', 'FEMALE', 'RATHER_NOT_SAY');

-- CreateEnum
CREATE TYPE "LengthUnit" AS ENUM ('CM', 'MM', 'MTR', 'FT');

-- CreateEnum
CREATE TYPE "WeightUnit" AS ENUM ('KG', 'LB');

-- CreateEnum
CREATE TYPE "Goal" AS ENUM ('BODY_RECOMPOSITION', 'STRENGTH', 'KEEPING_FIT', 'ATHLETICISM', 'OTHERS');

-- CreateEnum
CREATE TYPE "LevelOfExperience" AS ENUM ('BEGINNER', 'MID', 'ADVANCED', 'EXPERT');

-- CreateEnum
CREATE TYPE "ExcerciseMechanics" AS ENUM ('COMPOUND', 'ISOLATED');

-- CreateEnum
CREATE TYPE "ExcerciseForce" AS ENUM ('PUSH', 'PULL');

-- CreateEnum
CREATE TYPE "ExcerciseUtility" AS ENUM ('BASIC', 'AUXILIARY');

-- CreateEnum
CREATE TYPE "ExcerciseMetadataState" AS ENUM ('LEARNING', 'INCREASED_DIFFICULTY', 'DECREASED_DIFFICULTY', 'MAINTAINENCE');

-- CreateEnum
CREATE TYPE "Equipment" AS ENUM ('DUMBBELL', 'BARBELL', 'KETTLEBELL', 'CABLE', 'LEVER', 'SUSPENSION', 'T_BAR', 'MACHINE', 'TRAP_BAR', 'SLED', 'SMITH', 'BENCH', 'MEDICINE_BALL', 'PREACHER');

-- CreateEnum
CREATE TYPE "MuscleRegionType" AS ENUM ('HIPS', 'UPPER_ARM', 'SHOULDER', 'WAIST', 'CALVES', 'THIGHS', 'BACK', 'CHEST', 'FORE_ARM', 'NECK');

-- CreateEnum
CREATE TYPE "ExcerciseSetGroupState" AS ENUM ('DELETED_TEMPORARILY', 'DELETED_PERMANANTLY', 'REPLACEMENT_TEMPORARILY', 'REPLACEMENT_PERMANANTLY', 'NORMAL_OPERATION');

-- CreateTable
CREATE TABLE "User" (
    "user_id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "firebase_uid" TEXT NOT NULL,
    "displayName" TEXT NOT NULL,
    "prior_years_of_experience" DOUBLE PRECISION,
    "level_of_experience" "LevelOfExperience",
    "age" INTEGER,
    "dark_mode" BOOLEAN NOT NULL DEFAULT false,
    "automatic_scheduling" BOOLEAN NOT NULL DEFAULT true,
    "workout_frequency" INTEGER,
    "workout_duration" INTEGER,
    "goal" "Goal",
    "gender" "Gender",
    "weight" DOUBLE PRECISION,
    "height" DOUBLE PRECISION,
    "weight_unit" "WeightUnit",
    "height_unit" "LengthUnit",
    "phoneNumber" TEXT,
    "compound_movement_rep_lower_bound" INTEGER NOT NULL DEFAULT 3,
    "compound_movement_rep_upper_bound" INTEGER NOT NULL DEFAULT 10,
    "isolated_movement_rep_lower_bound" INTEGER NOT NULL DEFAULT 5,
    "isolated_movement_rep_upper_bound" INTEGER NOT NULL DEFAULT 15,
    "equipment_accessible" "Equipment"[],

    CONSTRAINT "User_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "ExcerciseMetadata" (
    "excercise_metadata_state" "ExcerciseMetadataState" NOT NULL DEFAULT E'LEARNING',
    "haveRequiredEquipment" BOOLEAN,
    "preferred" BOOLEAN,
    "last_excecuted" TIMESTAMP(3),
    "best_weight" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "weight_unit" "WeightUnit" NOT NULL DEFAULT E'KG',
    "best_rep" INTEGER NOT NULL DEFAULT 0,
    "rest_time_lower_bound" INTEGER NOT NULL DEFAULT 90,
    "rest_time_upper_bound" INTEGER NOT NULL DEFAULT 180,
    "user_id" INTEGER NOT NULL,
    "excercise_name" TEXT NOT NULL,

    CONSTRAINT "ExcerciseMetadata_pkey" PRIMARY KEY ("user_id","excercise_name")
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
    "workout_name" TEXT NOT NULL,
    "life_span" INTEGER NOT NULL,
    "order_index" INTEGER NOT NULL,
    "date_scheduled" TIMESTAMP(3),
    "date_completed" TIMESTAMP(3),
    "performance_rating" DOUBLE PRECISION,
    "user_id" INTEGER NOT NULL,

    CONSTRAINT "Workout_pkey" PRIMARY KEY ("workout_id")
);

-- CreateTable
CREATE TABLE "ExcerciseSetGroup" (
    "excercise_set_group_id" SERIAL NOT NULL,
    "excercise_name" TEXT NOT NULL,
    "workout_id" INTEGER NOT NULL,
    "excercise_set_group_state" "ExcerciseSetGroupState" NOT NULL,

    CONSTRAINT "ExcerciseSetGroup_pkey" PRIMARY KEY ("excercise_set_group_id")
);

-- CreateTable
CREATE TABLE "MuscleRegion" (
    "muscle_region_id" SERIAL NOT NULL,
    "muscle_region_name" TEXT NOT NULL,
    "muscle_region_description" TEXT,
    "muscle_region_type" "MuscleRegionType" NOT NULL,

    CONSTRAINT "MuscleRegion_pkey" PRIMARY KEY ("muscle_region_id")
);

-- CreateTable
CREATE TABLE "Excercise" (
    "excercise_name" TEXT NOT NULL,
    "excercise_preparation" TEXT,
    "excercise_instructions" TEXT,
    "excercise_tips" TEXT,
    "excercise_utility" "ExcerciseUtility"[],
    "excercise_mechanics" "ExcerciseMechanics"[],
    "excercise_force" "ExcerciseForce"[],
    "equipment_required" "Equipment"[],
    "body_weight" BOOLEAN NOT NULL,
    "assisted" BOOLEAN NOT NULL,

    CONSTRAINT "Excercise_pkey" PRIMARY KEY ("excercise_name")
);

-- CreateTable
CREATE TABLE "ExcerciseSet" (
    "excercise_set_id" SERIAL NOT NULL,
    "target_weight" DOUBLE PRECISION NOT NULL,
    "weight_unit" "WeightUnit" NOT NULL,
    "target_reps" INTEGER NOT NULL,
    "actual_weight" DOUBLE PRECISION,
    "actual_reps" INTEGER,
    "excercise_set_group_id" INTEGER NOT NULL,

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
    "A" TEXT NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_stabilizer" (
    "A" TEXT NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_synergist" (
    "A" TEXT NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_dynamic" (
    "A" TEXT NOT NULL,
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
CREATE UNIQUE INDEX "MuscleRegion_muscle_region_name_key" ON "MuscleRegion"("muscle_region_name");

-- CreateIndex
CREATE UNIQUE INDEX "_target_AB_unique" ON "_target"("A", "B");

-- CreateIndex
CREATE INDEX "_target_B_index" ON "_target"("B");

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

-- CreateIndex
CREATE UNIQUE INDEX "_BroadCastToUser_AB_unique" ON "_BroadCastToUser"("A", "B");

-- CreateIndex
CREATE INDEX "_BroadCastToUser_B_index" ON "_BroadCastToUser"("B");

-- AddForeignKey
ALTER TABLE "ExcerciseMetadata" ADD CONSTRAINT "ExcerciseMetadata_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ExcerciseMetadata" ADD CONSTRAINT "ExcerciseMetadata_excercise_name_fkey" FOREIGN KEY ("excercise_name") REFERENCES "Excercise"("excercise_name") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Measurement" ADD CONSTRAINT "Measurement_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Measurement" ADD CONSTRAINT "Measurement_muscle_region_id_fkey" FOREIGN KEY ("muscle_region_id") REFERENCES "MuscleRegion"("muscle_region_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Workout" ADD CONSTRAINT "Workout_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ExcerciseSetGroup" ADD CONSTRAINT "ExcerciseSetGroup_workout_id_fkey" FOREIGN KEY ("workout_id") REFERENCES "Workout"("workout_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ExcerciseSetGroup" ADD CONSTRAINT "ExcerciseSetGroup_excercise_name_fkey" FOREIGN KEY ("excercise_name") REFERENCES "Excercise"("excercise_name") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ExcerciseSet" ADD CONSTRAINT "ExcerciseSet_excercise_set_group_id_fkey" FOREIGN KEY ("excercise_set_group_id") REFERENCES "ExcerciseSetGroup"("excercise_set_group_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_target" ADD CONSTRAINT "_target_A_fkey" FOREIGN KEY ("A") REFERENCES "Excercise"("excercise_name") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_target" ADD CONSTRAINT "_target_B_fkey" FOREIGN KEY ("B") REFERENCES "MuscleRegion"("muscle_region_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_stabilizer" ADD CONSTRAINT "_stabilizer_A_fkey" FOREIGN KEY ("A") REFERENCES "Excercise"("excercise_name") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_stabilizer" ADD CONSTRAINT "_stabilizer_B_fkey" FOREIGN KEY ("B") REFERENCES "MuscleRegion"("muscle_region_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_synergist" ADD CONSTRAINT "_synergist_A_fkey" FOREIGN KEY ("A") REFERENCES "Excercise"("excercise_name") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_synergist" ADD CONSTRAINT "_synergist_B_fkey" FOREIGN KEY ("B") REFERENCES "MuscleRegion"("muscle_region_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_dynamic" ADD CONSTRAINT "_dynamic_A_fkey" FOREIGN KEY ("A") REFERENCES "Excercise"("excercise_name") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_dynamic" ADD CONSTRAINT "_dynamic_B_fkey" FOREIGN KEY ("B") REFERENCES "MuscleRegion"("muscle_region_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BroadCastToUser" ADD CONSTRAINT "_BroadCastToUser_A_fkey" FOREIGN KEY ("A") REFERENCES "BroadCast"("broad_cast_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BroadCastToUser" ADD CONSTRAINT "_BroadCastToUser_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;
