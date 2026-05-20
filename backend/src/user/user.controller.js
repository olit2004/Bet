/**
 * Auth Controller
 * Handles user registration, login, and account deletion.
 */
const userService = require('./user.service');
const bcrypt = require('bcryptjs');

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

// --- Login ---
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

    // Login successful (JWT token will be added in a future commit)
    res.status(200).json({
      status: 'success',
      message: 'Login successful.',
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
  // TODO: Implement delete account logic
  res.status(501).json({ message: 'Delete account not implemented yet' });
};

module.exports = { register, login, deleteAccount };
