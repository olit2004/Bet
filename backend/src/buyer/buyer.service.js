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
      role: true,
      isVerified: true,
      faydaId: true,
      createdAt: true,
      updatedAt: true,
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
      ...(data.email && { email: data.email })
    },
    select: {
      id: true,
      email: true,
      role: true,
      isVerified: true,
      faydaId: true,
      createdAt: true,
      updatedAt: true,
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

  if (user.isVerified) {
    const error = new Error('User is already verified with a Fayda ID.');
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
      isVerified: true,
      faydaId: faydaId.trim(),
    },
    select: {
      id: true,
      email: true,
      role: true,
      isVerified: true,
      faydaId: true,
      createdAt: true,
      updatedAt: true,
    }
  });

  return updatedUser;
};
