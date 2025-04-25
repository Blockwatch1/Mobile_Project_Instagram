import { Router } from 'express';
import authMiddleware from '../helpers/auth/verification.js';
import {
  createComment,
  createReply,
  deleteComment,
  editComment,
} from '../controllers/comment.controller.js';

export const router = Router();

//DELETE OPERATION
router.delete('/:commentId', authMiddleware, deleteComment);

//PUT OPERATION
router.put('/:commentId', authMiddleware, editComment);

//CREATE OPERATION
router.post('/create/:postId', authMiddleware, createComment);

router.post('/reply/:commentId', authMiddleware, createReply);
