-- DropForeignKey
ALTER TABLE "CoachClientRelationship" DROP CONSTRAINT "CoachClientRelationship_coach_id_fkey";

-- DropForeignKey
ALTER TABLE "CoachClientRelationship" DROP CONSTRAINT "CoachClientRelationship_user_id_fkey";

-- DropForeignKey
ALTER TABLE "FCMToken" DROP CONSTRAINT "FCMToken_baseUserBase_user_id_fkey";

-- DropForeignKey
ALTER TABLE "Measurement" DROP CONSTRAINT "Measurement_muscle_region_id_fkey";

-- DropForeignKey
ALTER TABLE "Measurement" DROP CONSTRAINT "Measurement_user_id_fkey";

-- DropForeignKey
ALTER TABLE "Notification" DROP CONSTRAINT "Notification_user_id_fkey";

-- DropForeignKey
ALTER TABLE "PrivateMessage" DROP CONSTRAINT "PrivateMessage_receiver_id_fkey";

-- DropForeignKey
ALTER TABLE "PrivateMessage" DROP CONSTRAINT "PrivateMessage_sender_id_fkey";

-- AddForeignKey
ALTER TABLE "PrivateMessage" ADD CONSTRAINT "PrivateMessage_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "BaseUser"("base_user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PrivateMessage" ADD CONSTRAINT "PrivateMessage_receiver_id_fkey" FOREIGN KEY ("receiver_id") REFERENCES "BaseUser"("base_user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CoachClientRelationship" ADD CONSTRAINT "CoachClientRelationship_coach_id_fkey" FOREIGN KEY ("coach_id") REFERENCES "Coach"("coach_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CoachClientRelationship" ADD CONSTRAINT "CoachClientRelationship_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FCMToken" ADD CONSTRAINT "FCMToken_baseUserBase_user_id_fkey" FOREIGN KEY ("baseUserBase_user_id") REFERENCES "BaseUser"("base_user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Measurement" ADD CONSTRAINT "Measurement_muscle_region_id_fkey" FOREIGN KEY ("muscle_region_id") REFERENCES "MuscleRegion"("muscle_region_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Measurement" ADD CONSTRAINT "Measurement_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;
