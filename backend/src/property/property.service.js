import prisma from '../shared/db.js';

class PropertyService {
  async createProperty(data) {
    return prisma.property.create({
      data: {
        title: data.title,
        description: data.description,
        price: parseFloat(data.price),
        value: data.value ? parseFloat(data.value) : null,
        location: data.location || 'Unknown Location',
        latitude: parseFloat(data.latitude),
        longitude: parseFloat(data.longitude),
        type: data.type,
        listingType: data.listingType || 'FIXED',
        sqFootage: data.sqFootage ? parseFloat(data.sqFootage) : null,
        imageUrls: data.imageUrls || [],
        endingAt: data.endingAt ? new Date(data.endingAt) : null,
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

    const properties = await prisma.property.findMany({
      where: { ownerId: sellerId },
      select: { views: true }
    });

    const totalViews = properties.reduce((sum, prop) => sum + (prop.views || 0), 0);
    
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
        bids: {
          include: {
            bidder: {
              include: {
                user: {
                  select: {
                    id: true,
                    email: true,
                    role: true,
                    name: true,
                    isVerified: true,
                  }
                }
              }
            }
          },
          orderBy: { amount: 'desc' }
        },
        proposals: {
          include: {
            bidder: {
              include: {
                user: {
                  select: {
                    id: true,
                    email: true,
                    role: true,
                    name: true,
                    isVerified: true,
                  }
                }
              }
            }
          },
          orderBy: { createdAt: 'desc' }
        },
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
