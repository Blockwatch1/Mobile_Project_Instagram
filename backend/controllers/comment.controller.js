import { PrismaClient } from '../lib/generated/prisma/client.js';
const prisma = new PrismaClient();

//DELETE OPERATION
export const deleteComment = async (req, res) => {
  const { commentId } = req.params;
  const userId = req?.user?.userId;

  try {
    const deleteComment = await prisma.comment.deleteMany({
      where: {
        commentId: Number(commentId),
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

//PUT OPERATIONS
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
        commentId: Number(commentId),
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

//CREATE OPERATION

//NORMAL COMMENT CREATION
export const createComment = async (req, res) => {
  const { postId } = req.params;
  const userId = req?.user?.userId;
  const { content } = req.body;

  try {
    if (content.length < 1) {
      return res.status(400).json({
        success: false,
        data: null,
        message: 'Comment content cannot be empty',
      });
    }

    const comment = await prisma.comment.create({
      data: {
        content,
        isReply: false,
        userId,
        postId: Number(postId),
      },
    });

    if (!comment) {
      return res.status(404).json({
        success: false,
        data: null,
        message: 'Comment not found',
      });
    }

    return res.status(201).json({
      success: true,
      data: comment,
      message: 'Comment created successfully',
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      data: null,
      message: 'Could not create comment',
    });
  }
};

export const createReply = async (req, res) => {
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
    const reply = await prisma.comment.create({
      data: {
        content,
        isReply: true,
        userId,
        replies: {
          connect: {
            replyId: Number(commentId),
          },
        },
        postId: null, //set postId null for replies because a reply's parent is a comment
      },
    });

    if (!reply) {
      return res.status(404).json({
        success: false,
        data: null,
        message: 'Reply not found',
      });
    }

    return res.status(201).json({
      success: true,
      data: reply,
      message: 'Reply created successfully',
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      data: null,
      message: 'Could not create reply',
    });
  }
};

export const getComments = async (req, res) => {
  const { postId } = req.params;

  try {
    const comments = await prisma.comment.findMany({
      where: {
        postId: Number(postId),
        isReply: false,
      },
      include: {
        user: {
          select: {
            userId: true,
            username: true,
            pfpPath: true,
            name: true,
          },
        },
        _count: {
          select: {
            replies: true,
          },
        },
      },
    });

    if (!comments) {
      return res.status(400).json({
        success: false,
        data: null,
        message: 'Couldnt fetch comments',
      });
    }

    return res.status(200).json({
      success: true,
      data: comments,
      message: 'Fetched comments successfully',
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      data: null,
      message: 'Could not get comments',
    });
  }
};
