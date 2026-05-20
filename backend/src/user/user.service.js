/**
 * User Service
 * Handles database operations for the User model via Prisma.
 */
const prisma = require('../shared/db');

/**
 * Create a new user in the database.
 */
const createUser = async ({ email, passwordHash, role }) => {
  return prisma.user.create({
    data: {
      email,
      passwordHash,
      role,
    },
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

module.exports = {
  createUser,
  findUserByEmail,
  findUserById,
  deleteUserById,
};
