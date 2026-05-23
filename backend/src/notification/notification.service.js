import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export class NotificationService {
  /**
   * Create a new notification
   * @param {string} userId - ID of the user receiving the notification
   * @param {string} message - Content of the notification
   * @param {string} type - Type/Category of the notification
   * @returns {Promise<Object>} Created notification
   */
  static async createNotification(userId, message, type) {
    try {
      const notification = await prisma.notification.create({
        data: {
          userId,
          message,
          type,
        },
      });
      return notification;
    } catch (error) {
      console.error('Error creating notification:', error);
      throw new Error('Failed to create notification');
    }
  }

  /**
   * Get all notifications for a specific user
   * @param {string} userId - User ID
   * @returns {Promise<Array>} List of notifications sorted by newest first
   */
  static async getUserNotifications(userId) {
    try {
      const notifications = await prisma.notification.findMany({
        where: { userId },
        orderBy: { createdAt: 'desc' },
      });
      return notifications;
    } catch (error) {
      console.error('Error fetching notifications:', error);
      throw new Error('Failed to fetch notifications');
    }
  }

  /**
   * Mark a specific notification as read
   * @param {string} notificationId - Notification ID
   * @param {string} userId - User ID to ensure they own the notification
   * @returns {Promise<Object>} Updated notification
   */
  static async markAsRead(notificationId, userId) {
    try {
      const notification = await prisma.notification.updateMany({
        where: {
          id: notificationId,
          userId: userId,
        },
        data: {
          isRead: true,
        },
      });
      
      if (notification.count === 0) {
        throw new Error('Notification not found or unauthorized');
      }

      return { success: true, message: 'Notification marked as read' };
    } catch (error) {
      console.error('Error marking notification as read:', error);
      throw error;
    }
  }
}
