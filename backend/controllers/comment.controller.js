import { PrismaClient } from '../lib/generated/prisma/client.js';
const prisma = new PrismaClient();

export const deleteComment = async (req, res) => {
  const { commentId } = req.params;
  const userId = req?.user?.userId;

  try {
    const deleteComment = await prisma.comment.deleteMany({
      where: {
        commentId,
        userId,
      },
    });

    if (!deleteComment) {
      return res.status(404).json({
        success: false,
        data: null,
        message: 'Comment not found',
      });
    }

    return res.status(200).json({
      success: true,
      data: deleteComment,
      message: 'Comment deleted successfully',
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      data: null,
      message: 'Could not delete comment',
    });
  }
};
