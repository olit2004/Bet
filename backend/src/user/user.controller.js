/**
 * Auth Controller
 * Handles user registration, login, and account deletion.
 */
import userService from './user.service.js';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';

// --- Register ---
const register = async (req, res, next) => {
  try {
    const { email, password, role, name, phone, company } = req.body;

    // Validate required fields
    if (!email || !password || !name || !phone) {
      return res.status(400).json({
        status: 'fail',
        message: 'Name, email, phone, and password are required.',
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

    // Create user with hashed password and additional info
    const user = await userService.createUser({
      email,
      passwordHash: hashedPassword,
      role: userRole,
      name,
      phone,
      company: userRole === 'SELLER' ? company : undefined,
    });

    res.status(201).json({
      status: 'success',
      message: 'User registered successfully.',
      data: {
        id: user.id,
        email: user.email,
        role: user.role,
        name: user.name,
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
        bio: user.bio,
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

// --- Upload Profile Image ---
const uploadProfileImage = async (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        status: 'fail',
        message: 'No image file provided.',
      });
    }

    const avatarUrl = `/public/uploads/${req.file.filename}`;
    
    // Update the user's avatarUrl
    // We import prisma here or update via userService.
    // Let's use userService to update user
    const updatedUser = await userService.updateUser(req.user.id, { avatarUrl });

    res.status(200).json({
      status: 'success',
      data: {
        id: updatedUser.id,
        email: updatedUser.email,
        role: updatedUser.role,
        name: updatedUser.name,
        avatarUrl: updatedUser.avatarUrl,
        bio: updatedUser.bio,
      },
    });
  } catch (error) {
    next(error);
  }
};

// --- Submit Fayda Verification ---
const submitVerification = async (req, res, next) => {
  try {
    const { faydaId } = req.body;

    if (!faydaId) {
      return res.status(400).json({
        status: 'fail',
        message: 'Fayda ID number is required.',
      });
    }

    if (!req.file) {
      return res.status(400).json({
        status: 'fail',
        message: 'Fayda ID image is required.',
      });
    }

    const faydaImageUrl = `/public/uploads/${req.file.filename}`;
    
    // Update the user's verification details
    const updatedUser = await userService.updateUser(req.user.id, { 
      faydaId, 
      faydaImageUrl,
      faydaStatus: 'PENDING'
    });

    res.status(200).json({
      status: 'success',
      message: 'Verification submitted successfully.',
      data: {
        id: updatedUser.id,
        email: updatedUser.email,
        role: updatedUser.role,
        name: updatedUser.name,
        avatarUrl: updatedUser.avatarUrl,
        faydaId: updatedUser.faydaId,
        faydaImageUrl: updatedUser.faydaImageUrl,
        faydaStatus: updatedUser.faydaStatus,
        isVerified: updatedUser.isVerified,
        bio: updatedUser.bio,
      },
    });
  } catch (error) {
    if (error.code === 'P2002') {
      return res.status(409).json({
        status: 'fail',
        message: 'This Fayda ID is already registered.',
      });
    }
    next(error);
  }
};

// --- Get Current User (Me) ---
const getMe = async (req, res, next) => {
  try {
    const user = await userService.findUserById(req.user.id);
    if (!user) {
      return res.status(404).json({
        status: 'fail',
        message: 'User not found.',
      });
    }

    res.status(200).json({
      status: 'success',
      data: {
        id: user.id,
        email: user.email,
        role: user.role,
        name: user.name,
        avatarUrl: user.avatarUrl,
        faydaId: user.faydaId,
        faydaImageUrl: user.faydaImageUrl,
        faydaStatus: user.faydaStatus,
        isVerified: user.isVerified,
        bio: user.bio,
      },
    });
  } catch (error) {
    next(error);
  }
};

const updateProfile = async (req, res, next) => {
  try {
    const { email, bio } = req.body;
    
    // Check email uniqueness if it's being updated
    if (email) {
      const existingEmail = await userService.findUserByEmail(email);
      if (existingEmail && existingEmail.id !== req.user.id) {
        return res.status(400).json({ status: 'fail', message: 'Email is already taken.' });
      }
    }

    const updatedUser = await userService.updateUser(req.user.id, { 
      ...(email && { email }),
      ...(bio !== undefined && { bio }),
    });

    res.status(200).json({
      status: 'success',
      data: {
        id: updatedUser.id,
        email: updatedUser.email,
        role: updatedUser.role,
        name: updatedUser.name,
        avatarUrl: updatedUser.avatarUrl,
        faydaId: updatedUser.faydaId,
        faydaImageUrl: updatedUser.faydaImageUrl,
        faydaStatus: updatedUser.faydaStatus,
        isVerified: updatedUser.isVerified,
        bio: updatedUser.bio,
      },
    });
  } catch (error) {
    next(error);
  }
};

export { register, login, deleteAccount, uploadProfileImage, submitVerification, getMe, updateProfile };
