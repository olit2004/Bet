import express from 'express';
const router = express.Router();
import * as bidController from './bid.controller.js';
import { verifyToken, authorizeRoles } from '../user/user.middleware.js';
import upload from '../shared/upload.middleware.js';

// Note: Since bids relate directly to properties, these routes handle both
// /api/bids and /api/properties/:propertyId/bids logic. 
// We will mount this router carefully in app.js.

// ----------------------------------------------------
// ----------------------------------------------------
// Property-specific Bid Routes (e.g. POST /api/properties/:propertyId/bids)
// ----------------------------------------------------

// Get my bids (Buyer) - Must be placed before /properties/:propertyId to avoid param collision
router.get('/my-bids', verifyToken, authorizeRoles('BUYER'), bidController.getMyBids);

// Retrieve all bids for a specific property (Accessible to any authenticated user)
router.get('/properties/:propertyId/bids', verifyToken, bidController.getPropertyBids);

// Place a new bid (Only BUYER can bid)
// Expects an optional PDF/Image file upload in the 'bankStatement' field
router.post(
  '/properties/:propertyId/bids',
  verifyToken,
  authorizeRoles('BUYER'),
  upload.single('bankStatement'),
  bidController.placeBid
);

// ----------------------------------------------------
// Direct Bid Routes (e.g. PATCH /api/bids/:id/...)
// ----------------------------------------------------

// Retract a bid (Only BUYER who owns the bid can retract)
router.patch('/bids/:id/retract', verifyToken, authorizeRoles('BUYER'), bidController.retractBid);

// Accept a bid (Only SELLER who owns the property can accept)
router.patch('/bids/:id/accept', verifyToken, authorizeRoles('SELLER'), bidController.acceptBid);

// Optional: Admin deletion route could go here.

export default router;
