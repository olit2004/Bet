import express from 'express';
import cors from 'cors';

import propertyRoutes from './property/property.routes.js';
import proposalsRoutes from './proposals/proposals.routes.js';

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/properties', propertyRoutes);
app.use('/api/proposals', proposalsRoutes);

// Base route for health check
app.get('/', (req, res) => {
  res.status(200).json({ message: 'Bet App API is running' });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: 'Internal Server Error', error: err.message });
});

export default app;
