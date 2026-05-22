import express from 'express';
const router = express.Router();
import { register } from './buyer.controller.js';
import { verifyToken, authorizeRoles } from '../user/user.middleware.js';

// POST /api/buyer/register — Upgrade GUEST → BUYER
router.post('/register', verifyToken, register);

export default router;
