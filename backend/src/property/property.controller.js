import propertyService from './property.service.js';

class PropertyController {
  async createProperty(req, res, next) {
    try {
      // Extract ownerId from authenticated user
      const propertyData = { ...req.body, ownerId: req.user.id };
      
      // Handle uploaded images
      if (req.files && req.files.length > 0) {
        propertyData.imageUrls = req.files.map(file => `/public/uploads/${file.filename}`);
      }
      
      const property = await propertyService.createProperty(propertyData);
      res.status(201).json({
        success: true,
        data: property,
      });
    } catch (error) {
      if (error.code === 'P2003') {
        return res.status(400).json({ 
          success: false, 
          message: 'Invalid owner ID. Seller does not exist.' 
        });
      }
      next(error);
    }
  }

  async getAllProperties(req, res, next) {
    try {
      const properties = await propertyService.getAllProperties();
      res.status(200).json({
        success: true,
        data: properties,
      });
    } catch (error) {
      next(error);
    }
  }

  async getPropertiesBySeller(req, res, next) {
    try {
      const properties = await propertyService.getPropertiesBySeller(req.params.sellerId);
      res.status(200).json({
        success: true,
        data: properties,
      });
    } catch (error) {
      next(error);
    }
  }

  async getSellerStats(req, res, next) {
    try {
      const stats = await propertyService.getSellerStats(req.params.sellerId);
      res.status(200).json({
        success: true,
        data: stats,
      });
    } catch (error) {
      next(error);
    }
  }

  async getPropertyById(req, res, next) {
    try {
      const property = await propertyService.getPropertyById(req.params.id);
      if (!property) {
        return res.status(404).json({ success: false, message: 'Property not found' });
      }
      res.status(200).json({
        success: true,
        data: property,
      });
    } catch (error) {
      next(error);
    }
  }

  async updateProperty(req, res, next) {
    try {
      // SECURITY: Prevent mass-assignment. We only extract fields that are safe to update.
      // This prevents a user from maliciously changing the ownerId or the property id.
      const { title, description, price, location, latitude, longitude, type, status, imageUrls, endingAt } = req.body;
      const updateData = { title, description, price, location, latitude, longitude, type, status, imageUrls, endingAt };
      
      // Remove undefined fields so Prisma doesn't try to update them
      Object.keys(updateData).forEach(key => updateData[key] === undefined && delete updateData[key]);

      const property = await propertyService.updateProperty(req.params.id, updateData);
      res.status(200).json({
        success: true,
        data: property,
      });
    } catch (error) {
      if (error.code === 'P2025') { // Prisma Record NotFound error
        return res.status(404).json({ success: false, message: 'Property not found' });
      }
      next(error);
    }
  }

  async deleteProperty(req, res, next) {
    try {
      await propertyService.deleteProperty(req.params.id);
      res.status(200).json({
        success: true,
        message: 'Property deleted successfully',
      });
    } catch (error) {
       if (error.code === 'P2025') {
        return res.status(404).json({ success: false, message: 'Property not found' });
      }
      next(error);
    }
  }
}

export default new PropertyController();
