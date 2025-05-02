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
  sharedUserInfo,
  signUp,
  unfollow,
  unlikePost,
  updateAccountSettings,
  updateProfile,
} from '../controllers/user.controller.js';
import multer from 'multer';
import { storage } from '../helpers/imageUpload.js';

export const router = Router();

const upload = multer({ storage });

//AUTHENTICATION ENDPOINTS

router.post('/signup', signUp);

router.post('/login', logIn);

router.get('/logout', authMiddleware);

//DELETE OPERATIONS

router.delete('/delete-user/:userId', authMiddleware, deleteUser);

//READ OPERATIONS

//USER WILL REQUEST THIS ENDPOINT WHEN HE ENTERS A USER'S PROFILE PAGE (COULD BE HIS OR NOT HIS)
router.get('/:userId', authMiddleware, getUserProfileInfo);

//GET USERS BASED ON SEARCH (username)
router.get('/search/:nameusername', authMiddleware, getUsersListOnSearch);

//GET USER INFORMATION FOR THE SHARED PREFERENCES
router.get('/get-info/shared-preferences', authMiddleware, sharedUserInfo);

//PUT OPERATIONS

//USER SAVES POST
router.put('/save-post/:postId', authMiddleware, savePost);

//USER LIKES POST
router.put('/like-post/:postId', authMiddleware, likePost);
router.put('/unlike-post/:postId', authMiddleware, unlikePost);

//UPDATE USER PROFILE
router.put('/update-profile', authMiddleware, upload.single('image'), updateProfile);

//UPDATE FOLLOWINGS LIST BY FOLLOWING/UNFOLLOWING A USER
router.put('/follow/:followingId', authMiddleware, follow);

router.put('/unfollow/:unfollowingId', authMiddleware, unfollow);

router.put('/update-account-settings/:userId', authMiddleware, updateAccountSettings);
