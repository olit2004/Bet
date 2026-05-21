import prisma from '../shared/prisma.client.js';

class PropertyService {
  async createProperty(data) {
    return prisma.property.create({
      data: {
        title: data.title,
        description: data.description,
        price: data.price,
        location: data.location,
        latitude: data.latitude,
        longitude: data.longitude,
        type: data.type,
        imageUrls: data.imageUrls || [],
        endingAt: data.endingAt,
        ownerId: data.ownerId,
      },
    });
  }

  async getAllProperties() {
    return prisma.property.findMany({
      include: {
        owner: {
          include: {
            user: {
              select: {
                email: true,
                role: true,
              }
            }
          }
        }
      }
    });
  }

  async getPropertiesBySeller(sellerId) {
    return prisma.property.findMany({
      where: { ownerId: sellerId },
      include: {
        _count: {
          select: { bids: true }
        }
      },
      orderBy: { createdAt: 'desc' }
    });
  }

  async getSellerStats(sellerId) {
    const activeProperties = await prisma.property.count({
      where: { ownerId: sellerId, status: 'ACTIVE' }
    });

    const totalBidsAggregation = await prisma.bid.count({
      where: { property: { ownerId: sellerId } }
    });

    const totalViewsAggregation = await prisma.property.aggregate({
      where: { ownerId: sellerId },
      _sum: { views: true }
    });

    const totalViews = totalViewsAggregation._sum.views || 0;
    
    // Simple conversion rate: (Total Bids / Total Views) * 100
    let conversionRate = 0;
    if (totalViews > 0) {
      conversionRate = ((totalBidsAggregation / totalViews) * 100).toFixed(1);
    }

    return {
      activeProperties,
      totalBids: totalBidsAggregation,
      totalViews,
      conversionRate: `${conversionRate}%`
    };
  }

  async getPropertyById(id) {
    return prisma.property.findUnique({
      where: { id },
      include: {
        owner: true,
        bids: true,
        proposals: true,
      },
    });
  }

  async updateProperty(id, data) {
    return prisma.property.update({
      where: { id },
      data,
    });
  }

  async deleteProperty(id) {
    return prisma.property.delete({
      where: { id },
    });
  }
}

export default new PropertyService();
