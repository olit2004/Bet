const buyerService = require('./buyer.service');

async function register(req, res, next) {
  try {
    const updatedUser = await buyerService.registerAsBuyer(req.user.id);
    res.status(201).json({ status: 'success', message: 'Successfully registered as a buyer.', data: updatedUser });
  } catch (error) {
    next(error);
  }
}

module.exports = { register };
