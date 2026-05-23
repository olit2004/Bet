import express from 'express';
import { getUserNotifications, markAsRead } from './notification.controller.js';
import { protect } from '../auth/auth.middleware.js';

const router = express.Router();

router.use(protect); // Require authentication for all notification routes

router.get('/', getUserNotifications);
router.patch('/:id/read', markAsRead);

export default router;
