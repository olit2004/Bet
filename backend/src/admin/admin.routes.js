import express from 'express';
import adminController from './admin.controller.js';
import { protectAdmin } from './admin.middleware.js';

const router = express.Router();

router.use(protectAdmin);
router.get('/dashboard', adminController.getDashboard);
router.get('/users', adminController.getUsers);
router.get('/users/:id', adminController.getUser);
router.patch('/users/:id/moderate', adminController.moderateUser);
router.get('/verifications/pending', adminController.getPendingIdentities);
router.post('/users/:id/verify-identity', adminController.verifyIdentity);
router.get('/properties/review', adminController.getPropertiesForReview);
router.patch('/properties/:id/review', adminController.reviewProperty);

export default router;
