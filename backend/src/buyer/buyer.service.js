import prisma from '../shared/db.js';

async function registerAsBuyer(userId) {
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
}

export { registerAsBuyer };
