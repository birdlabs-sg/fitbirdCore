-- CreateEnum
CREATE TYPE "ContentBlockType" AS ENUM ('FEATURE_GUIDE', 'FITNESS_CONTENT');

-- CreateTable
CREATE TABLE "ContentBlock" (
    "content_block_id" SERIAL NOT NULL,
    "content_block_type" "ContentBlockType" NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "video_url" TEXT,

    CONSTRAINT "ContentBlock_pkey" PRIMARY KEY ("content_block_id")
);
