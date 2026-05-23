import express from 'express';
const router = express.Router();
import { register, login, deleteAccount, uploadProfileImage, submitVerification, getMe } from './user.controller.js';

import { verifyToken } from './user.middleware.js';
import upload from '../shared/upload.middleware.js';

// POST /api/auth/register
router.post('/register', register);

// POST /api/auth/login
router.post('/login', login);

// GET /api/auth/me
router.get('/me', verifyToken, getMe);

// DELETE /api/auth/account
router.delete('/account', verifyToken, deleteAccount);

// PATCH /api/auth/profile-image
router.patch('/profile-image', verifyToken, upload.single('image'), uploadProfileImage);

// PATCH /api/auth/verification
router.patch('/verification', verifyToken, upload.single('faydaImage'), submitVerification);

export default router;
