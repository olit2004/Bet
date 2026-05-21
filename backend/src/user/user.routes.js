const express = require('express');
const router = express.Router();
const { register, login, deleteAccount } = require('./user.controller');

const { verifyToken } = require('./user.middleware');

// POST /api/auth/register
router.post('/register', register);

// POST /api/auth/login
router.post('/login', login);

// DELETE /api/auth/account
router.delete('/account', verifyToken, deleteAccount);

module.exports = router;
