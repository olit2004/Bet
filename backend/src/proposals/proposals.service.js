import prisma from '../shared/prisma.client.js';

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

  async updateProposalStatus(id, status) {
    return prisma.proposal.update({
      where: { id },
      data: { status }
    });
  }
}

export default new ProposalsService();
