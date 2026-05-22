import express from 'express';
const router = express.Router();
import { register, login, deleteAccount } from './user.controller.js';

import { verifyToken } from './user.middleware.js';

// POST /api/auth/register
router.post('/register', register);

// POST /api/auth/login
router.post('/login', login);

// DELETE /api/auth/account
router.delete('/account', verifyToken, deleteAccount);

export default router;
