/*
  Warnings:

  - You are about to drop the column `userUserId` on the `Post` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "Post" DROP CONSTRAINT "Post_userUserId_fkey";

-- AlterTable
ALTER TABLE "Post" DROP COLUMN "userUserId",
ADD COLUMN     "userId" INTEGER;

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("userId") ON DELETE SET NULL ON UPDATE CASCADE;
