const express = require('express');
const cors = require('cors');
const adminRoutes = require('./admin/admin.routes');
const errorHandler = require('./shared/error.middleware');

const app = express();

// Standard Middlewares
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health Check Endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    message: 'Bet backend service is running smoothly.',
    timestamp: new Date(),
  });
});

// Route Registrations
app.use('/api/admin', adminRoutes);

// Centralized Error Handling
app.use(errorHandler);

module.exports = app;
