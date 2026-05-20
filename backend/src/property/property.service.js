import prisma from '../shared/prisma.client.js';

class PropertyService {
  async createProperty(data) {
    return prisma.property.create({
      data: {
        title: data.title,
        description: data.description,
        price: data.price,
        latitude: data.latitude,
        longitude: data.longitude,
        type: data.type,
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
