const express = require('express');
const router = express.Router();
const buyerController = require('./buyer.controller');
const { verifyToken, authorizeRoles } = require('../user/user.middleware');

// POST /api/buyer/register — Upgrade GUEST → BUYER
router.post('/register', verifyToken, buyerController.register);

module.exports = router;
