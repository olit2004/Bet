import express from 'express';
import * as buyerController from './buyer.controller.js';
import { verifyToken, authorizeRoles } from '../user/user.middleware.js';

const router = express.Router();

// POST /api/buyer/register — Upgrade GUEST → BUYER
router.post('/register', verifyToken, buyerController.register);

// GET /api/buyer/profile — Get buyer profile
router.get('/profile', verifyToken, authorizeRoles('BUYER'), buyerController.getProfile);

// PUT /api/buyer/profile — Update buyer profile
router.put('/profile', verifyToken, authorizeRoles('BUYER'), buyerController.updateProfile);

export default router;
