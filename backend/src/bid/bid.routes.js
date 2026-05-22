import express from 'express';
const router = express.Router();
import * as bidController from './bid.controller.js';
import { verifyToken, authorizeRoles } from '../user/user.middleware.js';
import upload from '../shared/upload.middleware.js';


router.get('/properties/:propertyId/bids', verifyToken, bidController.getPropertyBids);

router.post(
  '/properties/:propertyId/bids',
  verifyToken,
  authorizeRoles('BUYER'),
  upload.single('bankStatement'),
  bidController.placeBid
);



router.patch('/bids/:id/retract', verifyToken, authorizeRoles('BUYER'), bidController.retractBid);


router.patch('/bids/:id/accept', verifyToken, authorizeRoles('SELLER'), bidController.acceptBid);



export default router;
