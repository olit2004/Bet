/**
 * User Service
 * Handles database operations for the User model via Prisma.
 */
import prisma from '../shared/prisma.client.js';

/**
 * Create a new user in the database.
 */
const createUser = async ({ email, passwordHash, role, name, phone, company }) => {
  const userData = {
    email,
    passwordHash,
    role,
    name,
    phone,
  };

  // Use Prisma nested writes to automatically create the related role profile
  if (role === 'BUYER') {
    userData.buyer = { create: {} };
  } else if (role === 'SELLER') {
    userData.seller = { create: { company: company || null } };
  }

  return prisma.user.create({
    data: userData,
  });
};

/**
 * Find a user by their email address.
 */
const findUserByEmail = async (email) => {
  return prisma.user.findUnique({
    where: { email },
  });
};

/**
 * Find a user by their ID.
 */
const findUserById = async (id) => {
  return prisma.user.findUnique({
    where: { id },
  });
};

/**
 * Delete a user by their ID.
 */
const deleteUserById = async (id) => {
  return prisma.user.delete({
    where: { id },
  });
};

export default {
  createUser,
  findUserByEmail,
  findUserById,
  deleteUserById,
};
