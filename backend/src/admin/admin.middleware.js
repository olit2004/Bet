import jwt from 'jsonwebtoken';
import prisma from '../shared/db.js';

const protectAdmin = async (req, res, next) => {
  try {
    if (
      process.env.NODE_ENV === 'development' &&
      process.env.BYPASS_ADMIN_AUTH === 'true'
    ) {
      req.user = {
        id: 'dev-admin-uuid-1234',
        email: 'dev-admin@bet.com',
        role: 'ADMIN',
        isVerified: true,
      };
      return next();
    }
    let token;
    if (
      req.headers.authorization &&
      req.headers.authorization.startsWith('Bearer')
    ) {
      token = req.headers.authorization.split(' ')[1];
    }
    if (!token) {
      return res.status(401).json({
        success: false,
        message: 'Access denied. No authorization token was provided.',
      });
    }
    const secret = process.env.JWT_SECRET || 'bet_secret_development_key_12345';
    const decoded = jwt.verify(token, secret);
    const user = await prisma.user.findUnique({
      where: { id: decoded.id },
      include: { admin: true },
    });
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Access denied. The user associated with this token does not exist.',
      });
    }
    if (user.role !== 'ADMIN') {
      return res.status(403).json({
        success: false,
        message: 'Access denied. Administrator privileges are required to perform this action.',
      });
    }
    req.user = user;
    next();
  } catch (error) {
    console.error('Admin authentication middleware error:', error.message);
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({
        success: false,
        message: 'Access token has expired. Please log in again.',
      });
    }
    return res.status(401).json({
      success: false,
      message: 'Authentication failed. Invalid or malformed token.',
    });
  }
};

export { protectAdmin };
