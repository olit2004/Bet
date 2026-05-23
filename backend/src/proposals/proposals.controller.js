import proposalsService from './proposals.service.js';
import { NotificationService } from '../notification/notification.service.js';
import prisma from '../shared/prisma.client.js';
class ProposalsController {
  async getProposalsByProperty(req, res, next) {
    try {
      const proposals = await proposalsService.getProposalsByProperty(req.params.propertyId);
      res.status(200).json({
        success: true,
        data: proposals,
      });
    } catch (error) {
      next(error);
    }
  }

  async getMyProposals(req, res, next) {
    try {
      const bidderId = req.user.id;
      const proposals = await proposalsService.getProposalsByBidder(bidderId);
      res.status(200).json({
        success: true,
        data: proposals,
      });
    } catch (error) {
      next(error);
    }
  }

  async createProposal(req, res, next) {
    try {
      const { propertyId } = req.params;
      const { amount, details } = req.body;
      const bidderId = req.user.id;

      let fileUrl = null;
      if (req.file) {
        fileUrl = `/public/uploads/${req.file.filename}`;
      }

      const proposalAmount = amount ? parseFloat(amount) : null;
      if (amount && isNaN(proposalAmount)) {
        return res.status(400).json({ success: false, message: 'Invalid amount provided.' });
      }

      const finalDetails = details || 'Counter offer or proposal submitted.';

      const newProposal = await proposalsService.createProposal(
        propertyId,
        bidderId,
        proposalAmount,
        finalDetails,
        fileUrl
      );

      // Notify Seller
      const property = await prisma.property.findUnique({
        where: { id: propertyId }
      });
      
      if (property && property.ownerId) {
        await NotificationService.createNotification(
          property.ownerId,
          `A new proposal has been submitted on your property (${property.title}).`,
          'NEW_PROPOSAL'
        ).catch(err => console.error('Notification error:', err));
      }

      res.status(201).json({
        success: true,
        message: 'Your proposal has been submitted successfully.',
        data: newProposal
      });
    } catch (error) {
      next(error);
    }
  }

  async updateProposalStatus(req, res, next) {
    try {
      const { status } = req.body;
      const sellerId = req.user.id;
      
      if (!['PENDING', 'ACCEPTED', 'REJECTED'].includes(status)) {
        return res.status(400).json({ success: false, message: 'Invalid status. Must be PENDING, ACCEPTED, or REJECTED.' });
      }

      const proposal = await proposalsService.updateProposalStatus(req.params.id, status, sellerId);
      
      if (proposal && proposal.bidderId) {
        await NotificationService.createNotification(
          proposal.bidderId,
          `Your proposal for property has been ${status.toLowerCase()}.`,
          `PROPOSAL_${status}`
        ).catch(err => console.error('Notification error:', err));
      }

      res.status(200).json({
        success: true,
        data: proposal,
        message: `Proposal status successfully updated to ${status}`
      });
    } catch (error) {
      if (error.code === 'P2025') {
        return res.status(404).json({ success: false, message: 'Proposal not found' });
      }
      next(error);
    }
  }
}

export default new ProposalsController();
