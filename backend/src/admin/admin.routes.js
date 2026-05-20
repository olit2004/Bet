const express = require('express');
const adminController = require('./admin.controller');
const { protectAdmin } = require('./admin.middleware');

const router = express.Router();

// Apply admin protection/authentication middleware to all routes in this file
router.use(protectAdmin);

/**
 * @route   GET /api/admin/dashboard
 * @desc    Fetch global ecosystem statistics and recent logs
 * @access  Admin
 */
router.get('/dashboard', adminController.getDashboard);

/**
 * @route   GET /api/admin/users
 * @desc    Get all users with search, role, and verification status filters
 * @access  Admin
 */
router.get('/users', adminController.getUsers);

/**
 * @route   GET /api/admin/users/:id
 * @desc    Get user details by ID including relation profile and logs
 * @access  Admin
 */
router.get('/users/:id', adminController.getUser);

/**
 * @route   PATCH /api/admin/users/:id/moderate
 * @desc    Moderate user account (change roles, manually change status)
 * @access  Admin
 */
router.patch('/users/:id/moderate', adminController.moderateUser);

/**
 * @route   GET /api/admin/verifications/pending
 * @desc    List pending Fayda user verification requests
 * @access  Admin
 */
router.get('/verifications/pending', adminController.getPendingIdentities);

/**
 * @route   POST /api/admin/users/:id/verify-identity
 * @desc    Approve/Reject a user's Fayda identification
 * @access  Admin
 */
router.post('/users/:id/verify-identity', adminController.verifyIdentity);

/**
 * @route   GET /api/admin/properties/review
 * @desc    Get all properties for auction approval / review
 * @access  Admin
 */
router.get('/properties/review', adminController.getPropertiesForReview);

/**
 * @route   PATCH /api/admin/properties/:id/review
 * @desc    Approve, end, or reject/close a property auction
 * @access  Admin
 */
router.patch('/properties/:id/review', adminController.reviewProperty);

module.exports = router;
