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
      select: { id: true, email: true, role: true, isVerified: true, faydaId: true, createdAt: true, updatedAt: true, bio: true },
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
      role: true,
      isVerified: true,
      faydaId: true,
      createdAt: true,
      updatedAt: true,
      bio: true,
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

  // Update user profile
  const updatedUser = await prisma.user.update({
    where: { id: userId },
    data: {
      ...(data.email && { email: data.email }),
      ...(data.bio !== undefined && { bio: data.bio }),
    },
    select: {
      id: true,
      email: true,
      role: true,
      isVerified: true,
      faydaId: true,
      createdAt: true,
      updatedAt: true,
      bio: true,
    }
  });

  return updatedUser;
};

export const verifyFayda = async (userId, faydaId) => {
  if (!faydaId || typeof faydaId !== 'string' || faydaId.trim().length < 10) {
    const error = new Error('Invalid Fayda ID format. Must be at least 10 characters long.');
    error.statusCode = 400;
    throw error;
  }

  const user = await prisma.user.findUnique({ where: { id: userId } });
  
  if (!user) {
    const error = new Error('User not found.');
    error.statusCode = 404;
    throw error;
  }

  if (user.isVerified || user.faydaStatus === 'APPROVED') {
    const error = new Error('User is already verified with a Fayda ID.');
    error.statusCode = 400;
    throw error;
  }

  if (user.faydaStatus === 'PENDING') {
    const error = new Error('Your verification request is already pending review.');
    error.statusCode = 400;
    throw error;
  }

  const existingFayda = await prisma.user.findUnique({ where: { faydaId: faydaId.trim() } });
  if (existingFayda) {
    const error = new Error('This Fayda ID is already registered to another user.');
    error.statusCode = 400;
    throw error;
  }

  const updatedUser = await prisma.user.update({
    where: { id: userId },
    data: {
      faydaId: faydaId.trim(),
      faydaStatus: 'PENDING',
    },
    select: {
      id: true,
      email: true,
      role: true,
      isVerified: true,
      faydaId: true,
      faydaStatus: true,
      createdAt: true,
      updatedAt: true,
      bio: true,
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
        select: { id: true, amount: true, status: true, createdAt: true, property: { select: { id: true, title: true, status: true, location: true, endTime: true, endingAt: true, imageUrls: true, description: true } } },
        orderBy: { createdAt: 'desc' }
      },
      proposals: {
        select: { id: true, amount: true, status: true, createdAt: true, property: { select: { id: true, title: true, status: true, location: true, endTime: true, endingAt: true, imageUrls: true, description: true } } },
        orderBy: { createdAt: 'desc' }
      }
    }
  });

  // If buyer profile doesn't exist yet (new user), return an empty dashboard
  if (!buyer) {
    return {
      statistics: {
        totalBids: 0,
        activeBids: 0,
        acceptedBids: 0,
        totalProposals: 0,
        pendingProposals: 0,
        acceptedProposals: 0
      },
      recentBids: [],
      recentProposals: []
    };
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
    recentBids: buyer.bids.slice(0, 5),
    recentProposals: buyer.proposals.slice(0, 5)
  };
};
