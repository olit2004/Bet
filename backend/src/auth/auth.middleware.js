import jwt from 'jsonwebtoken';
import prisma from '../shared/prisma.client.js';

const JWT_SECRET = process.env.JWT_SECRET || 'bet_jwt_super_secret_key_12345';


async function protect(req, res, next) {
  try {
    let token;

    // Check for authorization header and expect 'Bearer <token>' format
    if (
      req.headers.authorization &&
      req.headers.authorization.startsWith('Bearer')
    ) {
      token = req.headers.authorization.split(' ')[1];
    }

    if (!token) {
      const error = new Error('Not authorized. Token is missing.');
      error.statusCode = 401;
      return next(error);
    }

    // Verify JWT
    let decoded;
    try {
      decoded = jwt.verify(token, JWT_SECRET);
    } catch (err) {
      const error = new Error('Not authorized. Token is invalid or expired.');
      error.statusCode = 401;
      return next(error);
    }

    // Retrieve user associated with the token (supporting id/userId in payload)
    const targetUserId = decoded.id || decoded.userId;
    if (!targetUserId) {
      const error = new Error('Not authorized. Invalid token payload.');
      error.statusCode = 401;
      return next(error);
    }

    const user = await prisma.user.findUnique({
      where: { id: targetUserId },
      select: {
        id: true,
        email: true,
        role: true,
        isVerified: true,
        faydaId: true,
        createdAt: true,
        updatedAt: true,
      },
    });

    if (!user) {
      const error = new Error('The user belonging to this token no longer exists.');
      error.statusCode = 401;
      return next(error);
    }

    // Attach user to req.user for downstream middleware/handlers
    req.user = user;
    next();
  } catch (error) {
    next(error);
  }
}

/**
 * Restrict routes to specified user roles.
 * @param {...string} roles - Permitted roles (e.g. 'BUYER', 'SELLER', 'ADMIN')
 */
function restrictTo(...roles) {
  return (req, res, next) => {
    if (!req.user || !roles.includes(req.user.role)) {
      const error = new Error('You do not have permission to perform this action.');
      error.statusCode = 403;
      return next(error);
    }
    next();
  };
}

export { protect, restrictTo };
export default { protect, restrictTo };
