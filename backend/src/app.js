import express from 'express';
import cors from 'cors';
import path from 'path';
import { fileURLToPath } from 'url';

import propertyRoutes from './property/property.routes.js';
import proposalsRoutes from './proposals/proposals.routes.js';
import buyerRoutes from './buyer/buyer.routes.js';
import bidRoutes from './bid/bid.routes.js';
import authRoutes from './user/user.routes.js';

import errorMiddleware from './shared/error.middleware.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Serve static uploads
app.use('/public/uploads', express.static(path.join(__dirname, '../public/uploads')));

// Feature Routers
app.use('/api/properties', propertyRoutes);
app.use('/api/proposals', proposalsRoutes);
app.use('/api/buyer', buyerRoutes);
app.use('/api', bidRoutes); // Mounts /api/properties/... and /api/bids/...
app.use('/api/auth', authRoutes);

// Health Check
app.get('/api/health', (req, res) => {
  res.status(200).json({
    status: 'success',
    message: 'Bet API is running.'
  });
});

// Global Error Handler
app.use(errorMiddleware);

export default app;