const express = require('express');
const router = express.Router();
const buyerController = require('./buyer.controller');
const { protect, restrictTo } = require('../auth/auth.middleware');

// POST /api/buyer/register — Upgrade GUEST → BUYER
router.post('/register', protect, buyerController.register);

module.exports = router;
