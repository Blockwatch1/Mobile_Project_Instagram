import { PrismaClient } from '../lib/generated/prisma/client.js';
const prisma = new PrismaClient();

export const createPost = async (req, res) => {
  const user = req?.user;
  const { description, imageUrl } = req.body;

  try {
    const createPost = await prisma.post.create({
      data: {
        description,
        imageUrl,
        userId: user.userId,
      },
      include: {
        user: true,
      },
    });

    if (!createPost) {
      return res.status(400).json({
        message: 'Could not create post',
        success: false,
      });
    }

    return res.status(201).json({
      success: true,
      message: 'Created post successfully',
      data: createPost,
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      error: {
        details: err,
        description: 'Could not create post',
      },
      data: null,
    });
  }
};

export const editPost = async (req, res) => {
  const postId = req.params;
  const editingUser = req?.user;

  const { description, imageUrl } = req.body;

  if (!description && !imageUrl) {
    return res.status(400).json({
      success: false,
      message: 'User must provide a description or an image url to edit',
    });
  }

  //making sure the user that is using the application is the same as the one that created the post
  const postToEdit = await prisma.post.findUnique({
    where: { postId },
    select: { userId: true },
  });

  if (postToEdit?.userId !== editingUser?.userId) {
    return res.status(401).json({
      success: false,
      message: 'User is not authorized to edit another user post',
    });
  }

  try {
    //the user would have already fetched the post's information to display them on screen before changing them, fetching a post is in the post router and post controller

    if (description && !imageUrl) {
      const editDescription = await prisma.post.update({
        where: { postId },
        data: {
          description,
        },
      });

      if (!editDescription)
        return res
          .status(400)
          .json({ message: 'Could not edit description', success: false, data: null });

      return res.status(201).json({
        message: 'Edited post description successfully',
        success: true,
        data: editDescription,
      });
    }

    if (imageUrl && !description) {
      const editImageUrl = await prisma.post.update({
        where: { postId },
        data: {
          description,
        },
      });

      if (!editImageUrl)
        return res
          .status(400)
          .json({ message: 'Could not edit image', success: false, data: null });

      return res.status(201).json({
        message: 'Edited post image successfully',
        success: true,
        data: editImageUrl,
      });
    }

    if (imageUrl && description) {
      const editDescriptionAndImage = await prisma.post.update({
        where: { postId },
        data: {
          description,
          imageUrl,
        },
      });

      if (!editDescriptionAndImage)
        return res
          .status(400)
          .json({ message: 'Could not edit image and description', success: false, data: null });

      return res.status(201).json({
        message: 'Edited post description and image successfully',
        success: true,
        data: editDescriptionAndImage,
      });
    }
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      error: {
        details: err,
        description: 'Could not edit post',
      },
      data: null,
    });
  }
};
