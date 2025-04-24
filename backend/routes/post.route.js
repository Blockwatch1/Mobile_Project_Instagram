import { Router } from 'express';
import authMiddleware from '../helpers/auth/verification.js';
import { createPost, editPost } from '../controllers/post.controller.js';

export const router = Router();

//USER WILL CREATE A POST
router.post('/create-post', authMiddleware, createPost);

//USER: PUT (EDITING)

//USER WILL EDIT A POST (YOU CAN EDIT EITHER THE PROFILE PICTURE, THE DESCRIPTION OR BOTH)
router.put('/edit-post/:postId', authMiddleware, editPost);
