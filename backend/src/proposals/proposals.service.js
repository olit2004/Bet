import prisma from '../shared/db.js';

class ProposalsService {
  async getProposalsByProperty(propertyId) {
    return prisma.proposal.findMany({
      where: { propertyId },
      include: {
        bidder: {
          include: {
            user: {
              select: {
                email: true,
                role: true,
              }
            }
          }
        }
      },
      orderBy: { createdAt: 'desc' }
    });
  }

  async getProposalsByBidder(bidderId) {
    return prisma.proposal.findMany({
      where: { bidderId },
      include: {
        property: true
      },
      orderBy: { createdAt: 'desc' }
    });
  }

  async createProposal(propertyId, bidderId, amount, details, fileUrl = null) {
    return prisma.$transaction(async (tx) => {
      const property = await tx.property.findUnique({
        where: { id: propertyId }
      });

      if (!property) {
        const error = new Error('Property not found');
        error.statusCode = 404;
        throw error;
      }

      if (property.status !== 'ACTIVE') {
        const error = new Error('This property listing is no longer active');
        error.statusCode = 400;
        throw error;
      }

      const proposal = await tx.proposal.create({
        data: {
          propertyId,
          bidderId,
          amount,
          details,
          fileUrl,
          status: 'PENDING'
        }
      });

      return proposal;
    });
  }

  async updateProposalStatus(id, status, sellerId) {
    return prisma.$transaction(async (tx) => {
      const proposal = await tx.proposal.findUnique({
        where: { id },
        include: { property: true }
      });

      if (!proposal) {
        const error = new Error('Proposal not found');
        error.statusCode = 404;
        throw error;
      }

      if (proposal.property.ownerId !== sellerId) {
        const error = new Error('You do not have permission to update this proposal');
        error.statusCode = 403;
        throw error;
      }

      if (proposal.property.status !== 'ACTIVE') {
        const error = new Error('This property listing is already closed');
        error.statusCode = 400;
        throw error;
      }

      const updatedProposal = await tx.proposal.update({
        where: { id },
        data: { status }
      });

      if (status === 'ACCEPTED') {
        await tx.proposal.updateMany({
          where: {
            propertyId: proposal.propertyId,
            id: { not: id },
            status: 'PENDING'
          },
          data: { status: 'REJECTED' }
        });

        await tx.property.update({
          where: { id: proposal.propertyId },
          data: { status: 'ENDED' }
        });

        await tx.notification.create({
          data: {
            userId: proposal.bidderId,
            type: 'PROPOSAL_UPDATE',
            message: `Your proposal for property '${proposal.property.title}' has been accepted!`
          }
        });
      } else if (status === 'REJECTED') {
        await tx.notification.create({
          data: {
            userId: proposal.bidderId,
            type: 'PROPOSAL_UPDATE',
            message: `Your proposal for property '${proposal.property.title}' has been rejected.`
          }
        });
      }

      return updatedProposal;
    });
  }
}

export default new ProposalsService();
