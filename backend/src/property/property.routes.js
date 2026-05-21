import express from 'express';
import propertyController from './property.controller.js';

const router = express.Router();

router.post('/', propertyController.createProperty);
router.get('/', propertyController.getAllProperties);
router.get('/seller/:sellerId/stats', propertyController.getSellerStats);
router.get('/seller/:sellerId', propertyController.getPropertiesBySeller);
router.get('/:id', propertyController.getPropertyById);
router.put('/:id', propertyController.updateProperty);
router.delete('/:id', propertyController.deleteProperty);

export default router;
