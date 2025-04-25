import { Router } from 'express';
import authMiddleware from '../helpers/auth/verification.js';
import { deleteComment } from '../controllers/comment.controller.js';

export const router = Router();

//DELETE OPERATION
router.delete('/:commentId', authMiddleware, deleteComment);
