import { Router } from 'express';
import authMiddleware from '../helpers/auth/verification.js';
import { createPost, editPost, getPost, getPosts } from '../controllers/post.controller.js';

export const router = Router();

//CREATE OPERATIONS
router.post('/create-post', authMiddleware, createPost);

//DELETE OPERATIONS
router.delete('/delete-post/:postId', authMiddleware);

//PUT OPERATIONS

//USER WILL EDIT A POST (YOU CAN EDIT EITHER THE PROFILE PICTURE, THE DESCRIPTION OR BOTH)
router.put('/edit-post/:postId', authMiddleware, editPost);

//READ OPERATIONS

//this is for the main page
router.put('/get-posts', authMiddleware, getPosts);

//this is for the page of the saved posts in the user's profile (this is done as an indivual route to make the get profile info route more efficient)
router.put('/get-saved-posts/:userId', authMiddleware, getPost);
