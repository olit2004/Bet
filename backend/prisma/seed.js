import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  console.log('Starting seed process...');

  // 1. Create a demo seller user
  const passwordHash = await bcrypt.hash('password123', 12);
  const demoSeller = await prisma.user.upsert({
    where: { email: 'demo.seller@bet.com' },
    update: {},
    create: {
      email: 'demo.seller@bet.com',
      passwordHash,
      name: 'Demo Seller',
      role: 'SELLER',
      seller: {
        create: {
          company: 'Bet Demo Properties',
        },
      },
    },
  });

  console.log(`Created demo seller with ID: ${demoSeller.id}`);

  // 2. Clear existing properties owned by demo seller to avoid duplicates on re-run
  await prisma.property.deleteMany({
    where: { ownerId: demoSeller.id },
  });

  // 3. Insert Property 1: Exquisite Villa
  const p1 = await prisma.property.create({
    data: {
      title: 'Exquisite Villa',
      description: "Designed by renowned architect Marcus Thorne, this residence serves as a masterful dialogue between organic textures and stark industrial lines. Featuring floor-to-ceiling glass that dissolves the boundary between the interior gallery and the surrounding eucalyptus groves.",
      price: 12450000,
      latitude: 8.9806, // Default Addis Ababa coords
      longitude: 38.7578,
      address: 'Garment',
      locale: 'Bole Medhanialem',
      location: 'Garment, Bole Medhanialem',
      beds: 5,
      baths: 4,
      sqFootage: 500,
      type: 'SALE',
      status: 'ACTIVE',
      imageUrls: ['assets/images/the-glass-Pavillion.png'],
      ownerId: demoSeller.id,
    },
  });
  console.log(`Created Property 1: ${p1.title}`);

  // 4. Insert Property 2: Elegant Apartments
  const p2 = await prisma.property.create({
    data: {
      title: 'Elegant Apartments',
      description: "Designed by the visionary studio these residences offer a sophisticated interplay between urban rhythm and curated tranquility. Featuring expansive steel-framed windows that pull the city's shifting skyline into the living space, each unit balances raw exposed concrete with the warmth of hand-finished oak.",
      price: 7450000,
      latitude: 8.9806,
      longitude: 38.7578,
      address: 'Tsehay Realstate',
      locale: 'Sarbet',
      location: 'Tsehay Realstate, Sarbet',
      beds: 3,
      baths: 2,
      type: 'SALE',
      status: 'ACTIVE',
      imageUrls: ['assets/images/properties/apartment.png'],
      ownerId: demoSeller.id,
    },
  });
  console.log(`Created Property 2: ${p2.title}`);

  // 5. Insert Property 3: Modern Loft
  const p3 = await prisma.property.create({
    data: {
      title: 'Modern Loft',
      description: "Spacious open-plan office in a prime business district. Suitable for startups or established firms. Features high-speed internet connectivity and ample parking.",
      price: 850000,
      latitude: 8.9806,
      longitude: 38.7578,
      address: 'Mexico, Addis Ababa',
      locale: 'Mexico',
      location: 'Mexico, Addis Ababa',
      sqFootage: 120,
      type: 'RENT',
      status: 'ACTIVE',
      imageUrls: ['assets/images/skyline-retreat.png'],
      ownerId: demoSeller.id,
    },
  });
  console.log(`Created Property 3: ${p3.title}`);

  console.log('Seeding completed successfully!');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
