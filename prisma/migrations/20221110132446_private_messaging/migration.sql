-- CreateTable
CREATE TABLE "PrivateMessage" (
    "message_id" TEXT NOT NULL,
    "date_issued" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "sender_id" INTEGER NOT NULL,
    "receiver_id" INTEGER NOT NULL,

    CONSTRAINT "PrivateMessage_pkey" PRIMARY KEY ("message_id")
);

-- AddForeignKey
ALTER TABLE "PrivateMessage" ADD CONSTRAINT "PrivateMessage_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "BaseUser"("base_user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PrivateMessage" ADD CONSTRAINT "PrivateMessage_receiver_id_fkey" FOREIGN KEY ("receiver_id") REFERENCES "BaseUser"("base_user_id") ON DELETE RESTRICT ON UPDATE CASCADE;
