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

// POST /api/buyer/verify-fayda — Verify Fayda Digital ID
router.post('/verify-fayda', verifyToken, authorizeRoles('BUYER'), buyerController.verifyFayda);

// GET /api/buyer/dashboard — Get buyer dashboard statistics
router.get('/dashboard', verifyToken, authorizeRoles('BUYER'), buyerController.getDashboard);

export default router;
