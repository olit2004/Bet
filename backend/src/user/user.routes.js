const express = require('express');
const router = express.Router();
const { register, login, deleteAccount } = require('./user.controller');

// POST /api/auth/register
router.post('/register', register);

// POST /api/auth/login
router.post('/login', login);

// DELETE /api/auth/account
router.delete('/account', deleteAccount);

module.exports = router;
