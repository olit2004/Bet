import adminService from './admin.service.js';

const getDashboard = async (req, res, next) => {
  try {
    const stats = await adminService.getDashboardStats();
    return res.status(200).json({
      success: true,
      data: stats,
    });
  } catch (error) {
    next(error);
  }
};

const getUsers = async (req, res, next) => {
  try {
    const users = await adminService.getAllUsers(req.query);
    return res.status(200).json({
      success: true,
      count: users.length,
      data: users,
    });
  } catch (error) {
    next(error);
  }
};

const getUser = async (req, res, next) => {
  try {
    const user = await adminService.getUserById(req.params.id);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }
    return res.status(200).json({
      success: true,
      data: user,
    });
  } catch (error) {
    next(error);
  }
};

const moderateUser = async (req, res, next) => {
  try {
    const updatedUser = await adminService.moderateUser(
      req.params.id,
      req.body,
      req.user.id
    );
    return res.status(200).json({
      success: true,
      message: 'User account moderated successfully.',
      data: updatedUser,
    });
  } catch (error) {
    next(error);
  }
};

const getPendingIdentities = async (req, res, next) => {
  try {
    const pendingList = await adminService.getPendingIdentities();
    return res.status(200).json({
      success: true,
      count: pendingList.length,
      data: pendingList,
    });
  } catch (error) {
    next(error);
  }
};

const verifyIdentity = async (req, res, next) => {
  try {
    const { approve } = req.body;
    if (approve === undefined) {
      return res.status(400).json({
        success: false,
        message: "Missing 'approve' boolean in request body",
      });
    }
    const updatedUser = await adminService.verifyUserIdentity(
      req.params.id,
      approve,
      req.user.id
    );
    return res.status(200).json({
      success: true,
      message: `User identity ${approve ? 'verified/approved' : 'rejected'} successfully.`,
      data: updatedUser,
    });
  } catch (error) {
    next(error);
  }
};

const getPropertiesForReview = async (req, res, next) => {
  try {
    const properties = await adminService.getPropertiesForReview();
    return res.status(200).json({
      success: true,
      count: properties.length,
      data: properties,
    });
  } catch (error) {
    next(error);
  }
};

const reviewProperty = async (req, res, next) => {
  try {
    const { status } = req.body;
    if (!status) {
      return res.status(400).json({
        success: false,
        message: "Missing 'status' string in request body",
      });
    }
    const updatedProperty = await adminService.reviewProperty(
      req.params.id,
      status,
      req.user.id
    );
    return res.status(200).json({
      success: true,
      message: `Property status successfully updated to '${status}'.`,
      data: updatedProperty,
    });
  } catch (error) {
    next(error);
  }
};

export default {
  getDashboard,
  getUsers,
  getUser,
  moderateUser,
  getPendingIdentities,
  verifyIdentity,
  getPropertiesForReview,
  reviewProperty,
};
