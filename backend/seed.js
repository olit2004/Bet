import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const prisma = new PrismaClient();
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function main() {
  console.log('Starting seed...');

  // 1. Create a User (SELLER)
  const passwordHash = await bcrypt.hash('password123', 10);
  const user = await prisma.user.upsert({
    where: { email: 'seller@example.com' },
    update: {},
    create: {
      email: 'seller@example.com',
      passwordHash,
      name: 'Test Seller',
      role: 'SELLER',
      isVerified: true,
      seller: {
        create: {
          company: 'Test Real Estate Co.'
        }
      }
    },
    include: {
      seller: true
    }
  });
  console.log('Created seller user:', user.email);

  // 2. Ensure public/uploads exists
  const uploadsDir = path.join(__dirname, 'public', 'uploads');
  if (!fs.existsSync(uploadsDir)) {
    fs.mkdirSync(uploadsDir, { recursive: true });
  }

  // 3. Copy sample images from flutter assets
  const imageMapping = {
    'the-glass-Pavillion.png': '../assets/images/the-glass-Pavillion.png',
    'apartment.png': '../assets/images/properties/apartment.png',
    'Industrial-loft.png': '../assets/images/Industrial-loft.png',
    'skyline-retreat.png': '../assets/images/skyline-retreat.png',
    'villa.png': '../assets/images/properties/villa.png'
  };

  for (const [destName, relativeSrc] of Object.entries(imageMapping)) {
    const srcPath = path.join(__dirname, relativeSrc);
    const destPath = path.join(uploadsDir, destName);
    if (fs.existsSync(srcPath)) {
      fs.copyFileSync(srcPath, destPath);
      console.log(`Copied ${destName}`);
    } else {
      console.warn(`Source image not found: ${srcPath}`);
    }
  }

  const endingAt = new Date();
  endingAt.setDate(endingAt.getDate() + 2);

  // 4. Clear existing properties to avoid ID conflicts
  await prisma.bid.deleteMany({});
  await prisma.proposal.deleteMany({});
  await prisma.property.deleteMany({});
  console.log('Cleared existing properties, bids, and proposals.');

  // 5. Create 5 Properties
  const propertiesToSeed = [
    {
      title: '[LIVE] Exquisite Villa',
      description: 'Designed by renowned architect Marcus Thorne, this residence serves as a masterful dialogue between organic textures and stark industrial lines.',
      price: 12450000,
      listingType: 'AUCTION',
      latitude: 8.9806,
      longitude: 38.7578,
      address: 'Garment, Addis Ababa',
      locale: 'Bole Medhanialem',
      location: 'Addis Ababa',
      type: 'SALE',
      status: 'ACTIVE',
      beds: 5,
      baths: 4,
      sqFootage: 500,
      imageUrls: ['/public/uploads/the-glass-Pavillion.png'],
      endingAt: endingAt,
      ownerId: user.id
    },
    {
      title: '[LIVE] Elegant Apartments',
      description: 'Sophisticated modern apartments featuring high ceilings, premium finishes, and large windows with panoramic views.',
      price: 75000,
      listingType: 'FIXED',
      latitude: 9.0300,
      longitude: 38.7400,
      address: 'Tsehay Real Estate, Addis Ababa',
      locale: 'Sarbet',
      location: 'Addis Ababa',
      type: 'RENT',
      status: 'ACTIVE',
      beds: 3,
      baths: 2,
      sqFootage: 150,
      imageUrls: ['/public/uploads/apartment.png'],
      ownerId: user.id
    },
    {
      title: '[LIVE] Modern Industrial Loft',
      description: 'An open-concept loft space with exposed brick walls, polished concrete flooring, and dynamic lighting.',
      price: 9800000,
      listingType: 'AUCTION',
      latitude: 9.0150,
      longitude: 38.7660,
      address: 'Kazanchis, Addis Ababa',
      locale: 'Kazanchis',
      location: 'Addis Ababa',
      type: 'SALE',
      status: 'ACTIVE',
      beds: 2,
      baths: 2,
      sqFootage: 220,
      imageUrls: ['/public/uploads/Industrial-loft.png'],
      endingAt: endingAt,
      ownerId: user.id
    },
    {
      title: '[LIVE] Skyline Commercial Penthouse',
      description: 'High-end penthouse suite configured for executive business offices, boasting dynamic layouts and direct elevator access.',
      price: 150000,
      listingType: 'FIXED',
      latitude: 9.0200,
      longitude: 38.7500,
      address: 'Bole Road, Addis Ababa',
      locale: 'Bole',
      location: 'Addis Ababa',
      type: 'COMMERCIAL',
      status: 'ACTIVE',
      beds: 0,
      baths: 3,
      sqFootage: 350,
      imageUrls: ['/public/uploads/skyline-retreat.png'],
      ownerId: user.id
    },
    {
      title: '[LIVE] Prime Plaza Commercial Center',
      description: 'A premium commercial workspace/showroom option set up for open auctions, perfect for custom corporate branding.',
      price: 250000,
      listingType: 'AUCTION',
      latitude: 8.9950,
      longitude: 38.7800,
      address: 'CMC Road, Addis Ababa',
      locale: 'CMC',
      location: 'Addis Ababa',
      type: 'COMMERCIAL',
      status: 'ACTIVE',
      beds: 0,
      baths: 4,
      sqFootage: 600,
      imageUrls: ['/public/uploads/villa.png'],
      endingAt: endingAt,
      ownerId: user.id
    }
  ];

  for (const propertyData of propertiesToSeed) {
    const created = await prisma.property.create({
      data: propertyData
    });
    console.log(`Created property: ${created.title} (${created.type} - ${created.listingType})`);
  }

  console.log('Seed completed successfully!');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
