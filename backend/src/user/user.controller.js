/**
 * Auth Controller
 * Handles user registration, login, and account deletion.
 */
const userService = require('./user.service');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// --- Register ---
const register = async (req, res, next) => {
  try {
    const { email, password, role } = req.body;

    // Validate required fields
    if (!email || !password) {
      return res.status(400).json({
        status: 'fail',
        message: 'Email and password are required.',
      });
    }

    // Validate role
    const allowedRoles = ['BUYER', 'SELLER'];
    const userRole = allowedRoles.includes(role) ? role : 'BUYER';

    // Check if user already exists
    const existingUser = await userService.findUserByEmail(email);
    if (existingUser) {
      return res.status(409).json({
        status: 'fail',
        message: 'A user with this email already exists.',
      });
    }

    // Hash the password before storing
    const salt = await bcrypt.genSalt(12);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Create user with hashed password
    const user = await userService.createUser({
      email,
      passwordHash: hashedPassword,
      role: userRole,
    });

    res.status(201).json({
      status: 'success',
      message: 'User registered successfully.',
      data: {
        id: user.id,
        email: user.email,
        role: user.role,
      },
    });
  } catch (error) {
    next(error);
  }
};

const login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    // Validate required fields
    if (!email || !password) {
      return res.status(400).json({
        status: 'fail',
        message: 'Email and password are required.',
      });
    }

    // Find user by email
    const user = await userService.findUserByEmail(email);
    if (!user) {
      return res.status(401).json({
        status: 'fail',
        message: 'Invalid email or password.',
      });
    }

    // Compare password with stored hash
    const isPasswordValid = await bcrypt.compare(password, user.passwordHash);
    if (!isPasswordValid) {
      return res.status(401).json({
        status: 'fail',
        message: 'Invalid email or password.',
      });
    }

    // Login successful, generate JWT token
    const token = jwt.sign(
      { id: user.id, role: user.role },
      process.env.JWT_SECRET || 'fallback_secret',
      { expiresIn: process.env.JWT_EXPIRES_IN || '1d' }
    );

    res.status(200).json({
      status: 'success',
      message: 'Login successful.',
      token,
      data: {
        id: user.id,
        email: user.email,
        role: user.role,
      },
    });
  } catch (error) {
    next(error);
  }
};

// --- Delete Account ---
const deleteAccount = async (req, res, next) => {
  try {
    const userId = req.user.id; // Extracted from verifyToken middleware

    await userService.deleteUserById(userId);

    res.status(200).json({
      status: 'success',
      message: 'Account deleted successfully.',
    });
  } catch (error) {
    if (error.code === 'P2025') {
      // Prisma error: Record to delete does not exist.
      return res.status(404).json({
        status: 'fail',
        message: 'User not found.',
      });
    }
    next(error);
  }
};

module.exports = { register, login, deleteAccount };
