import proposalsService from './proposals.service.js';

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

  async updateProposalStatus(req, res, next) {
    try {
      const { status } = req.body;
      
      // Validate that the new status is allowed by the schema
      if (!['PENDING', 'ACCEPTED', 'REJECTED'].includes(status)) {
        return res.status(400).json({ success: false, message: 'Invalid status. Must be PENDING, ACCEPTED, or REJECTED.' });
      }

      const proposal = await proposalsService.updateProposalStatus(req.params.id, status);
      
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
