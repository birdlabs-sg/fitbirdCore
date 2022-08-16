-- AlterTable
ALTER TABLE "User" ADD COLUMN     "body_weight_rep_lower_bound" INTEGER NOT NULL DEFAULT 8,
ADD COLUMN     "body_weight_rep_upper_bound" INTEGER NOT NULL DEFAULT 20;
