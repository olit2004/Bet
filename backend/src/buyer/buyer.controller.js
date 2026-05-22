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
