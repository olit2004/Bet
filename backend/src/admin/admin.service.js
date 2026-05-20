const prisma = require('../shared/db');
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
  const isDbEmpty = (await prisma.user.count()) === 0;
  const revenue = isDbEmpty ? 4200000 : dbRevenue;
  const activeAuctions = isDbEmpty ? 142 : activeAuctionsCount;
  const pendingVerifications = isDbEmpty ? 28 : pendingVerificationsCount;
  const recentActivities = isDbEmpty 
    ? [
        {
          id: 'mock-1',
          title: 'New Bid: $1.2M',
          subtitle: 'Skyline Penthouse • 2m ago',
          type: 'BID',
          timestamp: new Date(Date.now() - 2 * 60000),
          avatar: '/images/auction.png',
        },
        {
          id: 'mock-2',
          title: 'Property Verified',
          subtitle: 'Oak Ridge Manor • 15m ago',
          type: 'VERIFICATION',
          timestamp: new Date(Date.now() - 15 * 60000),
          avatar: '/images/verify.png',
        },
        {
          id: 'mock-3',
          title: 'Sale Confirmed',
          subtitle: 'Azure Shores Villa • 42m ago',
          type: 'SALE',
          timestamp: new Date(Date.now() - 42 * 60000),
          avatar: '/images/clipboard.png',
        }
      ]
    : dbAuditLogs.map(log => ({
        id: log.id,
        title: log.action,
        subtitle: `${log.details} • ${log.user.email}`,
        type: 'LOG',
        timestamp: log.createdAt,
        avatar: '/images/verify.png',
      }));
  const weeklyChartData = [
    { day: 'Mon', volume: 40 },
    { day: 'Tue', volume: 70 },
    { day: 'Wed', volume: 50 },
    { day: 'Thu', volume: 90 },
    { day: 'Fri', volume: 60 },
    { day: 'Sat', volume: 100 },
    { day: 'Sun', volume: 110 }
  ];
  return {
    revenue,
    activeAuctions,
    pendingVerifications,
    recentActivities,
    weeklyChartData,
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
      createdAt: true,
      updatedAt: true,
      buyer: true,
      seller: true,
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
  await prisma.auditLog.create({
    data: {
      userId: adminUserId,
      action: 'USER_MODERATION',
      details: `Moderated user ${updatedUser.email}: role set to '${updatedUser.role}', verified set to '${updatedUser.isVerified}'`,
    },
  });
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
      ...(approve && user.role === 'GUEST' && { role: 'BUYER' }),
    },
  });
  await prisma.auditLog.create({
    data: {
      userId: adminUserId,
      action: approve ? 'IDENTITY_APPROVED' : 'IDENTITY_REJECTED',
      details: `${approve ? 'Approved' : 'Rejected'} Fayda ID ${user.faydaId || 'N/A'} for ${user.email}`,
    },
  });
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
  await prisma.auditLog.create({
    data: {
      userId: adminUserId,
      action: 'PROPERTY_REVIEWED',
      details: `Property '${property.title}' status set to '${status}' by admin`,
    },
  });
  return updatedProperty;
};
module.exports = {
  getDashboardStats,
  getAllUsers,
  getUserById,
  moderateUser,
  getPendingIdentities,
  verifyUserIdentity,
  getPropertiesForReview,
  reviewProperty,
};
