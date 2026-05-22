import express from 'express';
import propertyController from './property.controller.js';
import authMiddleware from '../auth/auth.middleware.js';
import upload from '../shared/upload.middleware.js';

const router = express.Router();
const { protect, restrictTo } = authMiddleware;

router.post('/', protect, restrictTo('SELLER'), upload.array('images', 5), propertyController.createProperty);
router.get('/', propertyController.getAllProperties);
router.get('/seller/:sellerId/stats', propertyController.getSellerStats);
router.get('/seller/:sellerId', propertyController.getPropertiesBySeller);
router.get('/:id', propertyController.getPropertyById);
router.put('/:id', propertyController.updateProperty);
router.delete('/:id', propertyController.deleteProperty);

export default router;
