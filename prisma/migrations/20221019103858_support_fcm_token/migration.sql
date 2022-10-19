-- CreateTable
CREATE TABLE "FCMToken" (
    "token" TEXT NOT NULL,
    "date_issued" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "baseUserBase_user_id" INTEGER NOT NULL,

    CONSTRAINT "FCMToken_pkey" PRIMARY KEY ("token")
);

-- AddForeignKey
ALTER TABLE "FCMToken" ADD CONSTRAINT "FCMToken_baseUserBase_user_id_fkey" FOREIGN KEY ("baseUserBase_user_id") REFERENCES "BaseUser"("base_user_id") ON DELETE RESTRICT ON UPDATE CASCADE;
