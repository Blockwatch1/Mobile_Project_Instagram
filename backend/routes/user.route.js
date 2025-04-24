import { Router } from 'express';

import authMiddleware from '../helpers/auth/verification.js';
import {
  getUserProfileInfo,
  getUsersListOnSearch,
  logIn,
  signUp,
} from '../controllers/user.controller.js';

export const router = Router();

//AUTHENTICATION ENDPOINTS

router.post('/signup', signUp);

router.post('/login', logIn);

//USER: READ

//USER WILL REQUEST THIS ENDPOINT WHEN HE ENTERS A USER'S PROFILE PAGE (COULD BE HIS OR NOT HIS)
router.get('/:userId', authMiddleware, getUserProfileInfo);

//READ USERS BASED ON SEARCH (username)
router.get('/search/:nameusername', authMiddleware, getUsersListOnSearch);
