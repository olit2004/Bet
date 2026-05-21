const express = require('express');
const cors = require('cors');

const app = express();

// --- Middleware ---
app.use(cors());
app.use(express.json());

const path = require('path');
app.use('/public/uploads', express.static(path.join(__dirname, '../public/uploads')));

// --- Feature Routers ---
const buyerRoutes = require('./buyer/buyer.routes');
const bidRoutes = require('./bid/bid.routes');

app.use('/api/buyer', buyerRoutes);
app.use('/api', bidRoutes); // Mounts /api/properties/... and /api/bids/...

// --- Health Check ---
app.get('/api/health', (req, res) => {
  res.status(200).json({ status: 'success', message: 'Bet API is running.' });
});

// --- Global Error Handler (must be last) ---
const errorMiddleware = require('./shared/error.middleware');
app.use(errorMiddleware);

module.exports = app;
