import * as buyerService from './buyer.service.js';

export const register = async (req, res, next) => {
  try {
    const updatedUser = await buyerService.registerAsBuyer(req.user.id);
    res.status(201).json({ status: 'success', message: 'Successfully registered as a buyer.', data: updatedUser });
  } catch (error) {
    next(error);
  }
};

export const getProfile = async (req, res, next) => {
  try {
    const profile = await buyerService.getBuyerProfile(req.user.id);
    res.status(200).json({ status: 'success', data: profile });
  } catch (error) {
    next(error);
  }
};

export const updateProfile = async (req, res, next) => {
  try {
    const updatedUser = await buyerService.updateBuyerProfile(req.user.id, req.body);
    res.status(200).json({ status: 'success', message: 'Profile updated successfully.', data: updatedUser });
  } catch (error) {
    next(error);
  }
};

export const verifyFayda = async (req, res, next) => {
  try {
    const { faydaId } = req.body;
    
    if (!faydaId) {
      return res.status(400).json({ status: 'fail', message: 'Please provide a faydaId in the request body.' });
    }

    const updatedUser = await buyerService.verifyFayda(req.user.id, faydaId);
    
    res.status(200).json({ 
      status: 'success', 
      message: 'Fayda ID successfully verified.', 
      data: updatedUser 
    });
  } catch (error) {
    next(error);
  }
};

export const getDashboard = async (req, res, next) => {
  try {
    const dashboardData = await buyerService.getBuyerDashboard(req.user.id);
    
    res.status(200).json({ 
      status: 'success', 
      data: dashboardData 
    });
  } catch (error) {
    next(error);
  }
};
