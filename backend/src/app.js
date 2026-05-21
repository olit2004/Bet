import express from 'express';
import cors from 'cors';

import propertyRoutes from './property/property.routes.js';
import proposalsRoutes from './proposals/proposals.routes.js';
import buyerRoutes from './buyer/buyer.routes.js';

import errorMiddleware from './shared/error.middleware.js';

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Feature Routers
app.use('/api/properties', propertyRoutes);
app.use('/api/proposals', proposalsRoutes);
app.use('/api/buyer', buyerRoutes);

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