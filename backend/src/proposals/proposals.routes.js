import express from 'express';
import proposalsController from './proposals.controller.js';

const router = express.Router();

router.get('/property/:propertyId', proposalsController.getProposalsByProperty);
router.patch('/:id/status', proposalsController.updateProposalStatus);

export default router;
