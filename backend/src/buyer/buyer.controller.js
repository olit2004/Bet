import { registerAsBuyer } from './buyer.service.js';

async function register(req, res, next) {
  try {
    const updatedUser = await registerAsBuyer(req.user.id);
    res.status(201).json({ status: 'success', message: 'Successfully registered as a buyer.', data: updatedUser });
  } catch (error) {
    next(error);
  }
}

export { register };
