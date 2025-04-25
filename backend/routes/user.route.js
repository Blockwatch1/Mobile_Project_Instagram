import { Router } from 'express';

import authMiddleware from '../helpers/auth/verification.js';
import {
  deleteUser,
  follow,
  getUserProfileInfo,
  getUsersListOnSearch,
  likePost,
  logIn,
  savePost,
  signUp,
  unfollow,
  updateAccountSettings,
  updateProfile,
} from '../controllers/user.controller.js';

export const router = Router();

//AUTHENTICATION ENDPOINTS

router.post('/signup', signUp);

router.post('/login', logIn);

//DELETE OPERATIONS

router.delete('/delete-user/:userId', authMiddleware, deleteUser);

//READ OPERATIONS

//USER WILL REQUEST THIS ENDPOINT WHEN HE ENTERS A USER'S PROFILE PAGE (COULD BE HIS OR NOT HIS)
router.get('/:userId', authMiddleware, getUserProfileInfo);

//GET USERS BASED ON SEARCH (username)
router.get('/search/:nameusername', authMiddleware, getUsersListOnSearch);

//PUT OPERATIONS

//USER SAVES POST
router.put('/save-post/:postId', authMiddleware, savePost);

//USER LIKES POST
router.put('/like-post/:postId', authMiddleware, likePost);

//UPDATE USER PROFILE
router.put('/update-profile', authMiddleware, updateProfile);

//UPDATE FOLLOWINGS LIST BY FOLLOWING/UNFOLLOWING A USER
router.put('/follow/:followingId', authMiddleware, follow);

router.put('/unfollow/:unfollowingId', authMiddleware, unfollow);

router.put('/update-account-settings/:userId', authMiddleware, updateAccountSettings);
