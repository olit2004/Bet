import express from 'express';
import buyerController from './buyer.controller.js';
import { verifyToken } from '../user/user.middleware.js';

const router = express.Router();

// POST /api/buyer/register — Upgrade GUEST → BUYER
router.post('/register', verifyToken, buyerController.register);

export default router;
