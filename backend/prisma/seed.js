import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting database seeding...');

  console.log('🧹 Cleaning existing database records...');
  await prisma.auditLog.deleteMany({});
  await prisma.notification.deleteMany({});
  await prisma.proposal.deleteMany({});
  await prisma.bid.deleteMany({});
  await prisma.property.deleteMany({});
  await prisma.admin.deleteMany({});
  await prisma.seller.deleteMany({});
  await prisma.buyer.deleteMany({});
  await prisma.user.deleteMany({});

  console.log('👥 Creating user accounts & profiles...');


  const adminUser = await prisma.user.create({
    data: {
      email: 'admin@bet.com',
      passwordHash: '$2a$12$HDEJTC/vvQI8.LdD6jLGP.OPgboNGvu5j/CkEm1LLRXKY0n0spVj2',
      role: 'ADMIN',
      isVerified: true,
      faydaId: 'FAYDA-ETH-777',
      admin: { create: {} },
    },
  });


  const buyerUser1 = await prisma.user.create({
    data: {
      email: 'lemi@buyer.com',
      passwordHash: '$2a$12$HDEJTC/vvQI8.LdD6jLGP.OPgboNGvu5j/CkEm1LLRXKY0n0spVj2',
      role: 'BUYER',
      isVerified: true,
      faydaId: 'FAYDA-ETH-101',
      buyer: { create: {} },
    },
  });

  const buyerUser2 = await prisma.user.create({
    data: {
      email: 'misganaw@buyer.com',
      passwordHash: '$2a$12$HDEJTC/vvQI8.LdD6jLGP.OPgboNGvu5j/CkEm1LLRXKY0n0spVj2',
      role: 'BUYER',
      isVerified: false,
      faydaId: 'FAYDA-ETH-102',
      buyer: { create: {} },
    },
  });

  const sellerUser1 = await prisma.user.create({
    data: {
      email: 'samuel@seller.com',
      passwordHash: '$2a$12$HDEJTC/vvQI8.LdD6jLGP.OPgboNGvu5j/CkEm1LLRXKY0n0spVj2',
      role: 'SELLER',
      isVerified: true,
      faydaId: 'FAYDA-ETH-201',
      seller: { create: {} },
    },
  });

  const sellerUser2 = await prisma.user.create({
    data: {
      email: 'reza@seller.com',
      passwordHash: '$2a$12$HDEJTC/vvQI8.LdD6jLGP.OPgboNGvu5j/CkEm1LLRXKY0n0spVj2',
      role: 'SELLER',
      isVerified: false,
      faydaId: 'FAYDA-ETH-202',
      seller: { create: {} },
    },
  });

  console.log('🏡 Creating property listings...');


  const prop1 = await prisma.property.create({
    data: {
      title: 'Skyline Penthouse',
      description: 'Stunning luxury penthouse in the heart of Addis Ababa with views of Bole.',
      price: 1200000.0,
      latitude: 9.03,
      longitude: 38.74,
      type: 'SALE',
      status: 'ACTIVE',
      ownerId: sellerUser1.id,
    },
  });

  const prop2 = await prisma.property.create({
    data: {
      title: 'Oak Ridge Manor',
      description: 'Elegant suburban estate with private gardens and modern finishes.',
      price: 850000.0,
      latitude: 8.98,
      longitude: 38.79,
      type: 'SALE',
      status: 'ACTIVE',
      ownerId: sellerUser1.id,
    },
  });

  const prop3 = await prisma.property.create({
    data: {
      title: 'Azure Shores Villa',
      description: 'Beautiful lakeside modern villa with scenic views in Bahir Dar.',
      price: 1500000.0,
      latitude: 11.59,
      longitude: 37.39,
      type: 'SALE',
      status: 'CLOSED',
      ownerId: sellerUser2.id,
    },
  });

  console.log('🔨 Creating bids & proposal interactions...');

  await prisma.bid.create({
    data: {
      propertyId: prop1.id,
      bidderId: buyerUser1.id,
      amount: 1250000.0,
      status: 'ACTIVE',
    },
  });

  await prisma.bid.create({
    data: {
      propertyId: prop1.id,
      bidderId: buyerUser2.id,
      amount: 1300000.0,
      status: 'ACTIVE',
    },
  });

  await prisma.proposal.create({
    data: {
      propertyId: prop2.id,
      bidderId: buyerUser1.id,
      details: 'Willing to purchase with 20% downpayment, remainder in 12 monthly installments.',
      status: 'PENDING',
    },
  });

  console.log('📝 Recording audit logs...');

  await prisma.auditLog.createMany({
    data: [
      {
        userId: adminUser.id,
        action: 'SYSTEM_STARTUP',
        details: 'System database seeded successfully.',
      },
      {
        userId: sellerUser1.id,
        action: 'PROPERTY_CREATED',
        details: "Created listing: 'Skyline Penthouse' auction.",
      },
      {
        userId: buyerUser1.id,
        action: 'BID_PLACED',
        details: "Placed a bid of $1,250,000 on 'Skyline Penthouse'.",
      },
      {
        userId: buyerUser2.id,
        action: 'BID_PLACED',
        details: "Outbid with $1,300,000 on 'Skyline Penthouse'.",
      },
      {
        userId: adminUser.id,
        action: 'USER_MODERATION',
        details: "Verified identity for user: 'lemi@buyer.com'.",
      },
    ],
  });

  console.log('🎉 Database seeding complete!');
}

main()
  .catch((e) => {
    console.error('❌ Seeding error:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
