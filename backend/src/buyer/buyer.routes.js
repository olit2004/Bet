import express from 'express';
import * as buyerController from './buyer.controller.js';
import { verifyToken, authorizeRoles } from '../user/user.middleware.js';

const router = express.Router();

// POST /api/buyer/register — Upgrade GUEST → BUYER
router.post('/register', verifyToken, buyerController.register);

router.get('/profile', verifyToken, authorizeRoles('BUYER'), buyerController.getProfile);
router.put('/profile', verifyToken, authorizeRoles('BUYER'), buyerController.updateProfile);
router.patch('/verify-fayda', verifyToken, authorizeRoles('BUYER'), buyerController.verifyFayda);
router.get('/dashboard', verifyToken, authorizeRoles('BUYER'), buyerController.getDashboard);
export default router;
