import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function main() {
  console.log('Starting seed process...');

  // Create demo seller
  const demoSeller = await prisma.user.upsert({
    where: { email: 'demo.seller@bet.com' },
    update: {},
    create: {
      email: 'demo.seller@bet.com',
      name: 'Demo Seller',
      passwordHash: 'hashed_password_placeholder', // Since it's just for relationships
      role: 'SELLER',
      phone: '+251911000000',
      isVerified: true,
      seller: {
        create: {
          company: 'Bet Demo Properties',
        }
      }
    },
    include: { seller: true }
  });

  const sellerId = demoSeller.seller.id;
  console.log(`Created demo seller with ID: ${sellerId}`);

  // Properties to seed
  const properties = [
    {
      title: "The Glass Pavilion",
      description: "Designed by renowned architect Marcus Thorne, this residence serves as a masterful dialogue between organic textures and stark industrial lines.",
      price: 44250000,
      latitude: 8.9806,
      longitude: 38.7578,
      address: "Bole, Addis Ababa",
      location: "Bole, Addis Ababa",
      beds: 5,
      baths: 6,
      type: "SALE",
      listingType: "AUCTION",
      status: "ACTIVE",
      imageUrls: ["assets/images/the glass Pavillion.png"],
      ownerId: sellerId,
    },
    {
      title: "Industrial Loft",
      description: "Exclusive rental in Adama.",
      price: 28200,
      latitude: 8.5414,
      longitude: 39.2689,
      address: "Mebrat-hayl, Adama",
      location: "Mebrat-hayl, Adama",
      type: "RENT",
      listingType: "FIXED",
      status: "ACTIVE",
      imageUrls: ["assets/images/Industrial loft.png"],
      ownerId: sellerId,
    },
    {
      title: "Skyline Retreat",
      description: "Luxurious skyline retreat rental.",
      price: 32500,
      latitude: 8.9890,
      longitude: 38.7890,
      address: "Bole Medanialem",
      location: "Bole Medanialem",
      type: "RENT",
      listingType: "FIXED",
      status: "ACTIVE",
      imageUrls: ["assets/images/skyline retreat.png"],
      ownerId: sellerId,
    },
    {
      title: "Garden Estate",
      description: "Beautiful garden estate rental.",
      price: 25000,
      latitude: 9.0192,
      longitude: 38.8020,
      address: "CMC, Addis Ababa",
      location: "CMC, Addis Ababa",
      type: "RENT",
      listingType: "FIXED",
      status: "ACTIVE",
      imageUrls: ["assets/images/garden state.png"],
      ownerId: sellerId,
    }
  ];

  for (let i = 0; i < properties.length; i++) {
    const p = properties[i];
    await prisma.property.create({ data: p });
    console.log(`Created Property ${i + 1}: ${p.title}`);
  }

  console.log('Seeding completed successfully!');
}

main()
  .catch(e => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
