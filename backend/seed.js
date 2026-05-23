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
  const sourceImage1 = path.join(__dirname, '../assets/images/the-glass-Pavillion.png');
  const sourceImage2 = path.join(__dirname, '../assets/images/properties/apartment.png');
  
  const destImage1 = path.join(uploadsDir, 'the-glass-Pavillion.png');
  const destImage2 = path.join(uploadsDir, 'apartment.png');

  if (fs.existsSync(sourceImage1)) {
    fs.copyFileSync(sourceImage1, destImage1);
    console.log('Copied the-glass-Pavillion.png');
  } else {
    console.warn('Source image 1 not found:', sourceImage1);
  }

  if (fs.existsSync(sourceImage2)) {
    fs.copyFileSync(sourceImage2, destImage2);
    console.log('Copied apartment.png');
  } else {
    console.warn('Source image 2 not found:', sourceImage2);
  }

  const endingAt = new Date();
  endingAt.setDate(endingAt.getDate() + 2);

  // 4. Create Properties
  const auctionProperty = await prisma.property.create({
    data: {
      title: '[LIVE] Exquisite Villa',
      description: 'This description is being loaded directly from the PostgreSQL Database! Designed by renowned architect Marcus Thorne.',
      price: 12450000,
      listingType: 'AUCTION',
      latitude: 8.9806,
      longitude: 38.7578,
      address: 'Garment',
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
    }
  });
  console.log('Created auction property:', auctionProperty.title);

  const rentalProperty = await prisma.property.create({
    data: {
      title: '[LIVE] Elegant Apartments',
      description: 'This is a LIVE rental property fetched from the backend. Designed by the visionary studio these residences offer a sophisticated interplay between urban rhythm and curated tranquility.',
      price: 7450000,
      listingType: 'FIXED',
      latitude: 9.0300,
      longitude: 38.7400,
      address: 'Tsehay Realstate',
      locale: 'Sarbet',
      location: 'Addis Ababa',
      type: 'RENT',
      status: 'ACTIVE',
      beds: 3,
      baths: 2,
      sqFootage: 150,
      imageUrls: ['/public/uploads/apartment.png'],
      ownerId: user.id
    }
  });
  console.log('Created rental property:', rentalProperty.title);

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
