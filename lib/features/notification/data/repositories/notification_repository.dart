import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../auth/infrastructure/data_sources/auth_local_data_source.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final String baseUrl = 'http://localhost:8080';
  final AuthLocalDataSource _authLocalDataSource = AuthLocalDataSource();

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final token = await _authLocalDataSource.getToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.get(
        Uri.parse('$baseUrl/api/notifications'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> notificationsData = data['data']['notifications'];
        return notificationsData.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final token = await _authLocalDataSource.getToken();
      if (token == null) throw Exception('Authentication required');

      final response = await http.patch(
        Uri.parse('$baseUrl/api/notifications/$notificationId/read'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to mark notification as read');
      }
    } catch (e) {
      throw Exception('Error updating notification: $e');
    }
  }
}
