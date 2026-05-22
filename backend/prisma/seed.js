import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  console.log('Starting to seed properties...');

  // Create a mock User
  const passwordHash = await bcrypt.hash('password123', 10);
  
  const user = await prisma.user.upsert({
    where: { email: 'seed_seller@example.com' },
    update: {},
    create: {
      email: 'seed_seller@example.com',
      passwordHash: passwordHash,
      name: 'John Doe Properties',
      phone: '+251911234567',
      role: 'SELLER',
      isVerified: true,
      faydaStatus: 'VERIFIED',
    },
  });

  console.log('Created User with ID:', user.id);

  // Create a Seller associated with the User
  const seller = await prisma.seller.upsert({
    where: { id: user.id },
    update: {},
    create: {
      id: user.id,
      company: 'Doe Luxury Real Estate',
    },
  });

  console.log('Created Seller with ID:', seller.id);

  // Clear existing properties by this seller to avoid duplicates on re-run
  await prisma.property.deleteMany({
    where: { ownerId: seller.id }
  });

  // Create Property 1 (Exquisite Villa)
  const prop1 = await prisma.property.create({
    data: {
      title: 'Exquisite Villa',
      description: 'A stunning modern luxury villa featuring a large swimming pool, contemporary architecture, large glass windows, and photorealistic evening lighting. Perfect for those seeking the ultimate luxury living experience.',
      price: 35000000.0, // 35M ETB
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
      ownerId: seller.id,
    }
  });

  console.log('Created Property 1:', prop1.title);

  // Create Property 2 (Elegant Apartments)
  const prop2 = await prisma.property.create({
    data: {
      title: 'Elegant Apartments',
      description: 'A high-end modern apartment building in the city center. Features sleek architecture, abundant natural light, and premium amenities. Experience urban living at its finest.',
      price: 85000.0, // 85k ETB per month
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
      ownerId: seller.id,
    }
  });

  console.log('Created Property 2:', prop2.title);

  // Create Property 3 (Modern Loft)
  const prop3 = await prisma.property.create({
    data: {
      title: 'Modern Loft',
      description: 'A stunning modern loft apartment interior with exposed brick walls, large industrial windows, high ceilings, and warm cozy lighting. A perfect blend of industrial chic and modern comfort.',
      price: 15000000.0, // 15M ETB
      value: 16500000.0,
      listingType: 'FIXED',
      latitude: 8.9890,
      longitude: 38.7890,
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
      ownerId: seller.id,
    }
  });

  console.log('Created Property 3:', prop3.title);

  console.log('Seeding finished successfully!');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
