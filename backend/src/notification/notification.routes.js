import express from 'express';
import { getUserNotifications, markAsRead } from './notification.controller.js';
import { authenticate } from '../shared/auth.middleware.js';

const router = express.Router();

router.use(authenticate); // Require authentication for all notification routes

router.get('/', getUserNotifications);
router.patch('/:id/read', markAsRead);

export default router;
