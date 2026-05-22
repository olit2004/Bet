import express from 'express';
import proposalsController from './proposals.controller.js';
import { protect, restrictTo } from '../auth/auth.middleware.js';
import upload from '../shared/upload.middleware.js';
const router = express.Router();

// Get my proposals (Buyer) - Must be before /property/:propertyId to avoid param collision
router.get('/my-proposals', protect, restrictTo('BUYER'), proposalsController.getMyProposals);

// Get proposals by property (Accessible to authenticated users)
router.get('/property/:propertyId', protect, proposalsController.getProposalsByProperty);

// Create a proposal (Buyer)
router.post(
  '/property/:propertyId',
  protect,
  restrictTo('BUYER'),
  upload.single('proposalFile'),
  proposalsController.createProposal
);

// Update proposal status (Seller)
router.patch('/:id/status', protect, restrictTo('SELLER'), proposalsController.updateProposalStatus);

export default router;
