import prisma from '../shared/prisma.client.js';

export const registerAsBuyer = async (userId) => {
  const user = await prisma.user.findUnique({ where: { id: userId } });

  if (!user) {
    const error = new Error('User not found.');
    error.statusCode = 404;
    throw error;
  }

  if (user.role !== 'GUEST') {
    const error = new Error(`Cannot register as a buyer. Current role is '${user.role}'.`);
    error.statusCode = 400;
    throw error;
  }

  const updatedUser = await prisma.$transaction(async (tx) => {
    await tx.buyer.create({ data: { id: userId } });
    return tx.user.update({
      where: { id: userId },
      data: { role: 'BUYER' },
      select: { id: true, email: true, role: true, isVerified: true, faydaId: true, createdAt: true, updatedAt: true },
    });
  });

  return updatedUser;
};

export const getBuyerProfile = async (userId) => {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    select: {
      id: true,
      email: true,
      name: true,
      phone: true,
      role: true,
      isVerified: true,
      faydaId: true,
      faydaImageUrl: true,
      faydaStatus: true,
      createdAt: true,
      updatedAt: true,
      buyer: {
        select: {
          budget: true,
          preferredPropertyType: true,
          preferredLocations: true,
        }
      }
    }
  });

  if (!user) {
    const error = new Error('User not found.');
    error.statusCode = 404;
    throw error;
  }

  return user;
};

export const updateBuyerProfile = async (userId, data) => {
  const user = await prisma.user.findUnique({ where: { id: userId } });
  if (!user) {
    const error = new Error('User not found.');
    error.statusCode = 404;
    throw error;
  }

  // Ensure email uniqueness if updating email
  if (data.email && data.email !== user.email) {
    const existingEmail = await prisma.user.findUnique({ where: { email: data.email } });
    if (existingEmail) {
      const error = new Error('Email is already taken.');
      error.statusCode = 400;
      throw error;
    }
  }

  // Update user profile and buyer attributes
  const updatedUser = await prisma.user.update({
    where: { id: userId },
    data: {
      ...(data.email && { email: data.email }),
      ...(data.name && { name: data.name }),
      ...(data.phone && { phone: data.phone }),
      buyer: {
        update: {
          ...(data.budget !== undefined && { budget: data.budget }),
          ...(data.preferredPropertyType !== undefined && { preferredPropertyType: data.preferredPropertyType }),
          ...(data.preferredLocations !== undefined && { preferredLocations: data.preferredLocations }),
        }
      }
    },
    select: {
      id: true,
      email: true,
      name: true,
      phone: true,
      role: true,
      isVerified: true,
      faydaId: true,
      faydaImageUrl: true,
      faydaStatus: true,
      createdAt: true,
      updatedAt: true,
      buyer: {
        select: {
          budget: true,
          preferredPropertyType: true,
          preferredLocations: true,
        }
      }
    }
  });

  return updatedUser;
};

export const verifyFayda = async (userId, faydaId, faydaImageUrl) => {
  if (!faydaId || typeof faydaId !== 'string' || faydaId.trim().length < 10) {
    const error = new Error('Invalid Fayda ID format. Must be at least 10 characters long.');
    error.statusCode = 400;
    throw error;
  }

  if (!faydaImageUrl) {
    const error = new Error('A Fayda ID card image is required for verification.');
    error.statusCode = 400;
    throw error;
  }

  const user = await prisma.user.findUnique({ where: { id: userId } });
  
  if (!user) {
    const error = new Error('User not found.');
    error.statusCode = 404;
    throw error;
  }

  if (user.faydaStatus === 'VERIFIED') {
    const error = new Error('User is already verified with a Fayda ID.');
    error.statusCode = 400;
    throw error;
  }

  // Check uniqueness only if it's a new faydaId submission
  if (faydaId.trim() !== user.faydaId) {
    const existingFayda = await prisma.user.findUnique({ where: { faydaId: faydaId.trim() } });
    if (existingFayda) {
      const error = new Error('This Fayda ID is already registered to another user.');
      error.statusCode = 400;
      throw error;
    }
  }

  const updatedUser = await prisma.user.update({
    where: { id: userId },
    data: {
      faydaId: faydaId.trim(),
      faydaImageUrl: faydaImageUrl,
      faydaStatus: 'PENDING', // Admin must approve before isVerified becomes true
    },
    select: {
      id: true,
      email: true,
      role: true,
      isVerified: true,
      faydaId: true,
      faydaImageUrl: true,
      faydaStatus: true,
      createdAt: true,
      updatedAt: true,
    }
  });

  return updatedUser;
};

export const getBuyerDashboard = async (userId) => {
  // We need to fetch aggregate data for the buyer
  // The buyer ID is the same as the userId.
  const buyer = await prisma.buyer.findUnique({
    where: { id: userId },
    include: {
      bids: {
        select: { id: true, amount: true, status: true, property: { select: { title: true, status: true } } }
      },
      proposals: {
        select: { id: true, amount: true, status: true, property: { select: { title: true, status: true } } }
      }
    }
  });

  if (!buyer) {
    const error = new Error('Buyer profile not found.');
    error.statusCode = 404;
    throw error;
  }

  // Calculate statistics
  const totalBids = buyer.bids.length;
  const activeBids = buyer.bids.filter(bid => bid.status === 'ACTIVE').length;
  const acceptedBids = buyer.bids.filter(bid => bid.status === 'ACCEPTED').length;

  const totalProposals = buyer.proposals.length;
  const pendingProposals = buyer.proposals.filter(prop => prop.status === 'PENDING').length;
  const acceptedProposals = buyer.proposals.filter(prop => prop.status === 'ACCEPTED').length;

  return {
    statistics: {
      totalBids,
      activeBids,
      acceptedBids,
      totalProposals,
      pendingProposals,
      acceptedProposals
    },
    recentBids: buyer.bids.slice(0, 5), // Return the 5 most recent bids
    recentProposals: buyer.proposals.slice(0, 5) // Return the 5 most recent proposals
  };
};
