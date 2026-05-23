import { NotificationService } from './notification.service.js';

export const getUserNotifications = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const notifications = await NotificationService.getUserNotifications(userId);
    
    res.status(200).json({
      status: 'success',
      data: {
        notifications
      }
    });
  } catch (error) {
    next(error);
  }
};

export const markAsRead = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const { id: notificationId } = req.params;
    
    await NotificationService.markAsRead(notificationId, userId);
    
    res.status(200).json({
      status: 'success',
      message: 'Notification marked as read'
    });
  } catch (error) {
    next(error);
  }
};
