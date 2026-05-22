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
      name: 'System Admin',
      phone: '+251911000000',
      role: 'ADMIN',
      isVerified: true,
      faydaId: 'FAYDA-ETH-777',
      admin: { create: {} },
    },
  });


  const buyerUser1 = await prisma.user.create({
    data: {
      email: 'le@gmail.com',
      passwordHash: '$2a$12$HDEJTC/vvQI8.LdD6jLGP.OPgboNGvu5j/CkEm1LLRXKY0n0spVj2',
      name: 'Lemi Gb',
      phone: '+251976768476',
      role: 'BUYER',
      isVerified: false,
      buyer: { create: {} },
    },
  });

  const buyerUser2 = await prisma.user.create({
    data: {
      email: 'test100@bet.com',
      passwordHash: '$2a$12$HDEJTC/vvQI8.LdD6jLGP.OPgboNGvu5j/CkEm1LLRXKY0n0spVj2',
      name: 'Test User',
      phone: '12345',
      role: 'BUYER',
      isVerified: false,
      buyer: { create: {} },
    },
  });

  const sellerUser1 = await prisma.user.create({
    data: {
      email: 'pauldiracr@gmail.com',
      passwordHash: '$2a$12$HDEJTC/vvQI8.LdD6jLGP.OPgboNGvu5j/CkEm1LLRXKY0n0spVj2',
      name: 'Paul Dirac',
      phone: '0985992191',
      role: 'SELLER',
      isVerified: false,
      seller: { create: {} },
    },
  });

  const sellerUser2 = await prisma.user.create({
    data: {
      email: 'seed_seller@example.com',
      passwordHash: '$2a$12$HDEJTC/vvQI8.LdD6jLGP.OPgboNGvu5j/CkEm1LLRXKY0n0spVj2',
      name: 'John Doe Properties',
      phone: '+251911234567',
      role: 'SELLER',
      isVerified: true,
      seller: { create: {} },
    },
  });

  console.log('🏡 Creating property listings...');


  const prop1 = await prisma.property.create({
    data: {
      title: 'Exquisite Villa',
      description: 'A stunning modern luxury villa featuring a large swimming pool, contemporary architecture, large glass windows, and photorealistic evening lighting. Perfect for those seeking the ultimate luxury living experience.',
      price: 35000000.0,
      value: 38000000.0,
      listingType: 'FIXED',
      latitude: 8.9806,
      longitude: 38.7578,
      address: 'Bole Rwanda, Near Japanese Embassy',
      locale: 'Bole',
      location: 'Addis Ababa',
      beds: 6,
      baths: 5,
      sqFootage: 1200.0,
      type: 'SALE',
      status: 'ACTIVE',
      views: 312,
      imageUrls: ['/public/uploads/villa.png'],
      ownerId: sellerUser2.id,
    },
  });

  const prop2 = await prisma.property.create({
    data: {
      title: 'Elegant Apartments',
      description: 'A high-end modern apartment building in the city center. Features sleek architecture, abundant natural light, and premium amenities. Experience urban living at its finest.',
      price: 85000.0,
      value: 90000.0,
      listingType: 'FIXED',
      latitude: 9.0249,
      longitude: 38.7468,
      address: 'Kazanchis, ECA Road',
      locale: 'Kazanchis',
      location: 'Addis Ababa',
      beds: 3,
      baths: 2,
      sqFootage: 150.5,
      type: 'RENT',
      status: 'ACTIVE',
      views: 184,
      imageUrls: ['/public/uploads/apartment.png'],
      ownerId: sellerUser2.id,
    },
  });

  const prop3 = await prisma.property.create({
    data: {
      title: 'Modern Loft',
      description: 'A stunning modern loft apartment interior with exposed brick walls, large industrial windows, high ceilings, and warm cozy lighting. A perfect blend of industrial chic and modern comfort.',
      price: 15000000.0,
      value: 16500000.0,
      listingType: 'FIXED',
      latitude: 8.989,
      longitude: 38.789,
      address: 'Gerji, Imperial Hotel Road',
      locale: 'Gerji',
      location: 'Addis Ababa',
      beds: 1,
      baths: 1,
      sqFootage: 85.0,
      type: 'SALE',
      status: 'ACTIVE',
      views: 420,
      imageUrls: ['/public/uploads/loft.png'],
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
        details: "Verified identity for user: 'seed_seller@example.com'.",
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
