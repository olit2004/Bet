const express = require('express');
const cors = require('cors');

const app = express();

// --- Middleware ---
app.use(cors());
app.use(express.json());

// --- Feature Routers ---
const buyerRoutes = require('./buyer/buyer.routes');
app.use('/api/buyer', buyerRoutes);

const authRoutes = require('./user/user.routes');
app.use('/api/auth', authRoutes);

// --- Health Check ---
app.get('/api/health', (req, res) => {
  res.status(200).json({ status: 'success', message: 'Bet API is running.' });
});

// --- Global Error Handler (must be last) ---
const errorMiddleware = require('./shared/error.middleware');
app.use(errorMiddleware);

module.exports = app;
