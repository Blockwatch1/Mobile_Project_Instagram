-- AlterTable
ALTER TABLE "Comment" ADD COLUMN     "postPostId" INTEGER,
ADD COLUMN     "userUserId" INTEGER;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_postPostId_fkey" FOREIGN KEY ("postPostId") REFERENCES "Post"("postId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_userUserId_fkey" FOREIGN KEY ("userUserId") REFERENCES "User"("userId") ON DELETE SET NULL ON UPDATE CASCADE;
