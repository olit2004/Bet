import prisma from '../shared/db.js';
import bcrypt from 'bcryptjs';

const getDashboardStats = async () => {
  const activeAuctionsCount = await prisma.property.count({
    where: { status: 'ACTIVE' },
  });
  const pendingVerificationsCount = await prisma.user.count({
    where: {
      isVerified: false,
      faydaId: { not: null },
      role: { not: 'ADMIN' },
    },
  });
  const closedProperties = await prisma.property.findMany({
    where: { status: 'CLOSED' },
    select: { price: true },
  });
  const dbRevenue = closedProperties.reduce((sum, prop) => sum + prop.price, 0);
  const dbAuditLogs = await prisma.auditLog.findMany({
    take: 10,
    orderBy: { createdAt: 'desc' },
    include: {
      user: {
        select: {
          email: true,
          role: true,
        },
      },
    },
  });
  const recentActivities = dbAuditLogs.map(log => ({
    id: log.id,
    title: log.action,
    subtitle: `${log.details} • ${log.user.email}`,
    type: 'LOG',
    timestamp: log.createdAt,
    avatar: '/images/verify.png',
  }));

  const weeklyChartData = [];

  const adminUser = await prisma.user.findFirst({
    where: { role: 'ADMIN' },
    select: { email: true, role: true, createdAt: true, name: true }
  });

  return {
    revenue: dbRevenue,
    activeAuctions: activeAuctionsCount,
    pendingVerifications: pendingVerificationsCount,
    recentActivities,
    weeklyChartData,
    adminName: adminUser?.name || 'Admin',
    adminEmail: adminUser?.email || 'admin@bet.com',
    adminRole: adminUser?.role || 'ADMIN',
    memberSince: adminUser ? adminUser.createdAt.getFullYear().toString() : '',
  };
};

const getAllUsers = async (query = {}) => {
  const { role, isVerified, search } = query;
  const where = {};
  if (role) {
    where.role = role;
  }
  if (isVerified !== undefined) {
    where.isVerified = isVerified === 'true' || isVerified === true;
  }
  if (search) {
    where.OR = [
      { email: { contains: search, mode: 'insensitive' } },
      { faydaId: { contains: search, mode: 'insensitive' } },
    ];
  }
  return await prisma.user.findMany({
    where,
    select: {
      id: true,
      email: true,
      role: true,
      isVerified: true,
      faydaId: true,
      faydaStatus: true,
      name: true,
      phone: true,
      avatarUrl: true,
      faydaImageUrl: true,
      createdAt: true,
      updatedAt: true,
    },
    orderBy: { createdAt: 'desc' },
  });
};

const getUserById = async (userId) => {
  return await prisma.user.findUnique({
    where: { id: userId },
    select: {
      id: true,
      email: true,
      role: true,
      isVerified: true,
      faydaId: true,
      faydaStatus: true,
      name: true,
      phone: true,
      avatarUrl: true,
      faydaImageUrl: true,
      createdAt: true,
      updatedAt: true,
      buyer: true,
      seller: {
        include: {
          properties: true,
        },
      },
      auditLogs: {
        take: 10,
        orderBy: { createdAt: 'desc' },
      },
    },
  });
};

const moderateUser = async (userId, data, adminUserId) => {
  const { role, isVerified } = data;
  const updatedUser = await prisma.user.update({
    where: { id: userId },
    data: {
      ...(role && { role }),
      ...(isVerified !== undefined && { isVerified }),
    },
  });
  let actualAdminId = adminUserId;
  if (adminUserId === 'dev-admin-uuid-1234') {
    const fallbackAdmin = await prisma.user.findFirst({ where: { role: 'ADMIN' } });
    if (fallbackAdmin) actualAdminId = fallbackAdmin.id;
  }

  if (actualAdminId !== 'dev-admin-uuid-1234') {
    await prisma.auditLog.create({
      data: {
        userId: actualAdminId,
        action: 'USER_MODERATION',
        details: `Moderated user ${updatedUser.email}: role set to '${updatedUser.role}', verified set to '${updatedUser.isVerified}'`,
      },
    });
  }
  return updatedUser;
};

const getPendingIdentities = async () => {
  return await prisma.user.findMany({
    where: {
      isVerified: false,
      faydaId: { not: null },
      role: { not: 'ADMIN' },
    },
    select: {
      id: true,
      email: true,
      name: true,
      phone: true,
      avatarUrl: true,
      faydaImageUrl: true,
      faydaId: true,
      createdAt: true,
    },
    orderBy: { createdAt: 'desc' },
  });
};

const verifyUserIdentity = async (userId, approve, adminUserId) => {
  const user = await prisma.user.findUnique({ where: { id: userId } });
  if (!user) throw new Error('User not found');
  const updatedUser = await prisma.user.update({
    where: { id: userId },
    data: {
      isVerified: approve,
      faydaStatus: approve ? 'APPROVED' : 'REJECTED',
      ...(approve && user.role === 'GUEST' && { role: 'BUYER' }),
    },
  });
  let actualAdminId = adminUserId;
  if (adminUserId === 'dev-admin-uuid-1234') {
    const fallbackAdmin = await prisma.user.findFirst({ where: { role: 'ADMIN' } });
    if (fallbackAdmin) actualAdminId = fallbackAdmin.id;
  }

  if (actualAdminId !== 'dev-admin-uuid-1234') {
    await prisma.auditLog.create({
      data: {
        userId: actualAdminId,
        action: approve ? 'IDENTITY_APPROVED' : 'IDENTITY_REJECTED',
        details: `${approve ? 'Approved' : 'Rejected'} Fayda ID ${user.faydaId || 'N/A'} for ${user.email}`,
      },
    });
  }
  return updatedUser;
};

const getPropertiesForReview = async () => {
  return await prisma.property.findMany({
    include: {
      owner: {
        include: {
          user: {
            select: {
              email: true,
            },
          },
        },
      },
    },
    orderBy: { createdAt: 'desc' },
  });
};

const reviewProperty = async (propertyId, status, adminUserId) => {
  const property = await prisma.property.findUnique({
    where: { id: propertyId },
    include: { owner: { include: { user: true } } },
  });
  if (!property) throw new Error('Property not found');
  const updatedProperty = await prisma.property.update({
    where: { id: propertyId },
    data: { status }, 
  });
  let actualAdminId = adminUserId;
  if (adminUserId === 'dev-admin-uuid-1234') {
    const fallbackAdmin = await prisma.user.findFirst({ where: { role: 'ADMIN' } });
    if (fallbackAdmin) actualAdminId = fallbackAdmin.id;
  }

  if (actualAdminId !== 'dev-admin-uuid-1234') {
    await prisma.auditLog.create({
      data: {
        userId: actualAdminId,
        action: 'PROPERTY_REVIEWED',
        details: `Property '${property.title}' status set to '${status}' by admin`,
      },
    });
  }
  return updatedProperty;
};

const updateAdminPassword = async (userId, oldPassword, newPassword) => {
  const user = await prisma.user.findUnique({ where: { id: userId } });
  
  if (!user) throw new Error('User not found');

  const isPasswordValid = await bcrypt.compare(oldPassword, user.passwordHash);
  if (!isPasswordValid) {
    const error = new Error('Invalid old password');
    error.status = 401;
    throw error;
  }

  const salt = await bcrypt.genSalt(12);
  const hashedPassword = await bcrypt.hash(newPassword, salt);

  await prisma.user.update({
    where: { id: user.id },
    data: { passwordHash: hashedPassword },
  });
};

const deleteAdminAccount = async (userId) => {
  await prisma.user.delete({
    where: { id: userId },
  });
};

export default {
  getDashboardStats,
  getAllUsers,
  getUserById,
  moderateUser,
  getPendingIdentities,
  verifyUserIdentity,
  getPropertiesForReview,
  reviewProperty,
  updateAdminPassword,
  deleteAdminAccount,
};
