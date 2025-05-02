import { PrismaClient } from '../lib/generated/prisma/client.js';
const prisma = new PrismaClient();
import dotenv from 'dotenv';

dotenv.config();

//CREATE OPERATIONS (A post can be a thread or a post, if it is a thread, it will not have an image url)
export const createPost = async (req, res) => {
  const user = req?.user;
  const { description, isThread } = req.body;

  const isThreadBoolean = isThread === 'true';

  const file = req?.file;

  const createPostQueryObject = {
    description,
    userId: user.userId,
  };

  if (!isThreadBoolean) {
    if (file) {
      try {
        const formData = new FormData();

        const base64Image = file.buffer.toString('base64');
        formData.append('image', base64Image);

        console.log('Uploading image to ImgBB...');

        const imageBBResponse = await fetch(
          `https://api.imgbb.com/1/upload?key=${process.env.IMAGE_BB_API_KEY}`,
          {
            method: 'POST',
            body: formData,
          },
        );

        const result = await imageBBResponse.json();
        console.log('ImgBB response:', result);

        if (result && result.data && result.data.url) {
          createPostQueryObject.imageUrl = result.data.url;
          console.log('Image URL:', createPostQueryObject.imageUrl);
        } else {
          console.error('Invalid ImgBB response:', result);
        }
      } catch (imageError) {
        console.error('Error uploading image:', imageError);
      }
    } else {
      console.log('No file attached to the request');
    }
  }

  try {
    const createPost = await prisma.post.create({
      data: createPostQueryObject,
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
    console.error('Database error:', err);
    return res.status(500).json({
      success: false,
      error: {
        details: err.message,
        description: 'Could not create post',
      },
      data: null,
    });
  }
};

//DELETE OPERATIONS
export const deletePost = async (req, res) => {
  console.log('IM HERE!')
  try {
    const { postId } = req.params;
    const userId = req?.user.userId;

    //fetch post to check if the user is the one that created it
    const postToDelete = await prisma.post.findUnique({
      where: { postId: Number(postId) },
      select: { userId: true },
    });

    if (!postToDelete) {
      return res.status(400).json({
        message: 'Could not find post',
        success: false,
        data: null,
      });
    }

    if (postToDelete.userId !== userId) {
      return res.status(401).json({
        message: 'User is not authorized to delete another user post',
        success: false,
        data: null,
      });
    }

    const deletePost = await prisma.post.delete({
      where: { postId: Number(postId) },
    });

    if (!deletePost) {
      return res.status(400).json({
        message: 'Could not delete post',
        success: false,
        data: null,
      });
    }

    return res.status(200).json({
      message: 'Deleted post successfully',
      success: true,
      data: deletePost,
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      error: {
        details: err,
        description: 'Could not delete post',
      },
      data: null,
    });
  }
};

//PUT OPERATIONS
export const editPost = async (req, res) => {
  const { postId } = req.params;
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
    where: { postId: Number(postId) },
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
        where: { postId: Number(postId) },
        data: {
          description,
        },
      });

      if (!editDescription)
        return res
          .status(400)
          .json({ message: 'Could not edit description', success: false, data: null });

      return res.status(200).json({
        message: 'Edited post description successfully',
        success: true,
        data: editDescription,
      });
    }

    if (imageUrl && !description) {
      const editImageUrl = await prisma.post.update({
        where: { postId: Number(postId) },
        data: {
          description,
        },
      });

      if (!editImageUrl)
        return res
          .status(400)
          .json({ message: 'Could not edit image', success: false, data: null });

      return res.status(200).json({
        message: 'Edited post image successfully',
        success: true,
        data: editImageUrl,
      });
    }

    if (imageUrl && description) {
      const editDescriptionAndImage = await prisma.post.update({
        where: { postId: Number(postId) },
        data: {
          description,
          imageUrl,
        },
      });

      if (!editDescriptionAndImage)
        return res
          .status(400)
          .json({ message: 'Could not edit image and description', success: false, data: null });

      return res.status(200).json({
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

//READ OPERATIONS
export const getPosts = async (req, res) => {
  const userId = req?.user?.userId;

  console.log('testing post endpoint');

  try {
    const posts = await prisma.post.findMany({
      include: {
        user: {
          select: {
            pfpPath: true,
            name: true,
            username: true,
            userId: true,
          },
        },
        _count: {
          select: {
            comments: true,
            likedUsers: true,
            savedUsers: true,
          },
        },
        likedUsers: {
          where: { userId },
          select: { userId: true },
        },
        savedUsers: {
          where: { userId },
          select: { userId: true },
        },
      },
    });

    if (!posts) {
      return res.status(400).json({
        message: 'Could not fetch posts',
        data: null,
        success: false,
      });
    }

    return res.status(200).json({
      success: true,
      data: posts,
      message: 'Retreived posts successfully',
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      data: null,
      message: 'Could not retreive posts',
    });
  }
};

export const getUserSavedPosts = async (req, res) => {
  const { userId } = req.params;
  if (Number(userId) === req?.user?.userId) {
    try {
      const savedPosts = await prisma.user.findUnique({
        where: { userId: Number(userId) },
        select: {
          savedPosts: {
            include: {
              _count: {
                select: {
                  likedUsers: true,
                  savedUsers: true,
                  comments: true,
                },
              },
            },
          },
        },
      });

      if (!savedPosts) {
        return res.status(400).json({
          message: 'Could not fetch saved posts',
          data: null,
          success: false,
        });
      }

      return res.status(200).json({
        success: true,
        data: posts,
        message: 'Retreived saved posts successfully',
      });
    } catch (err) {
      console.error(err);
      return res.status(500).json({
        success: false,
        data: null,
        message: 'Could not retreive saved posts',
      });
    }
  } else {
    return res.status(401).json({
      message: 'Only the saved posts user can see his saved post',
      success: false,
      data: null,
    });
  }
};

export const getPost = async (req, res) => {
  const { postId } = req.params;

  try {
    const post = await prisma.post.findUnique({
      where: { postId: Number(postId) },
      include: {
        likedUsers: {
          select: {
            username: true,
            pfpPath: true,
          },
        },
        savedUsers: {
          select: {
            username: true,
            pfpPath: true,
          },
        },
      },
    });

    if (!post) {
      return res.status(400).json({
        message: 'Could not find post',
        data: null,
        success: false,
      });
    }

    return res.status(200).json({
      success: true,
      data: post,
      message: 'Retreived post successfully',
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      data: null,
      message: 'Could not retreive post',
    });
  }
};
