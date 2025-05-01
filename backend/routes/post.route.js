import { Router } from 'express';
import authMiddleware from '../helpers/auth/verification.js';
import {
  createPost,
  deletePost,
  editPost,
  getPost,
  getPosts,
  getUserSavedPosts,
} from '../controllers/post.controller.js';
import { storage } from '../helpers/imageUpload.js';
import multer from 'multer';

export const postRouter = Router();
const upload = multer({ storage });

//CREATE OPERATIONS
postRouter.post('/create-post', authMiddleware, upload.single('image'), createPost);

//DELETE OPERATIONS
postRouter.delete('/delete-post/:postId', authMiddleware, deletePost);

//PUT OPERATIONS

//USER WILL EDIT A POST (YOU CAN EDIT EITHER THE PROFILE PICTURE, THE DESCRIPTION OR BOTH)
postRouter.put('/edit-post/:postId', authMiddleware, editPost);

//READ OPERATIONS

//this is for the main page
postRouter.get('/get-posts', authMiddleware, getPosts);

//this is for the page of the saved posts in the user's profile (this is done as an indivual route to make the get profile info route more efficient)
postRouter.get('/get-saved-posts/:userId', authMiddleware, getUserSavedPosts);

postRouter.get('/get-post/:postId', authMiddleware, getPost);
