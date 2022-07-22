-- AlterTable
ALTER TABLE "User" ADD COLUMN     "compound_movement_rep_lower_bound" INTEGER NOT NULL DEFAULT 3,
ADD COLUMN     "compound_movement_rep_upper_bound" INTEGER NOT NULL DEFAULT 10,
ADD COLUMN     "isolated_movement_rep_lower_bound" INTEGER NOT NULL DEFAULT 5,
ADD COLUMN     "isolated_movement_rep_upper_bound" INTEGER NOT NULL DEFAULT 15;
