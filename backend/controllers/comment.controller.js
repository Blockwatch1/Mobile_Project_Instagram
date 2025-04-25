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

export const editComment = async (req, res) => {
  const { commentId } = req.params;
  const userId = req?.user?.userId;
  const { content } = req.body;

  if (content.length < 1) {
    return res.status(400).json({
      success: false,
      data: null,
      message: 'Comment content cannot be empty',
    });
  }

  try {
    const comment = await prisma.comment.update({
      where: {
        commentId,
        userId,
      },
      data: {
        content,
        updatedAt: new Date(),
        isEdited: true,
      },
    });

    if (!comment) {
      return res.status(404).json({
        success: false,
        data: null,
        message: 'Comment not found',
      });
    }

    return res.status(200).json({
      success: true,
      data: comment,
      message: 'Comment edited successfully',
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      data: null,
      message: 'Could not edit comment',
    });
  }
};
