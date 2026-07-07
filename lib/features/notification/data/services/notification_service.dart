import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/api_constants.dart';

class AppNotification {
  final int id;
  final String type;
  final String title;
  final String? body;
  final String? relatedType;
  final int? relatedId;
  final bool isRead;
  final String createdAt;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    this.body,
    this.relatedType,
    this.relatedId,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      body: json['body'],
      relatedType: json['related_type'],
      relatedId: json['related_id'],
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }
}

class NotificationService extends ChangeNotifier {
  List<AppNotification> _notifications = [];
  int _unreadCount = 0;
  Timer? _timer;

  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _unreadCount;

  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> fetchNotifications() async {
    try {
      final headers = await _authHeaders();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/notifications'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _notifications = (data['data'] as List)
            .map((e) => AppNotification.fromJson(e))
            .toList();
        _unreadCount = data['unread_count'] ?? 0;
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> fetchUnreadCount() async {
    try {
      final headers = await _authHeaders();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/notifications/unread-count'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _unreadCount = data['unread_count'] ?? 0;
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> markRead(List<int> ids) async {
    try {
      final headers = await _authHeaders();
      headers['Content-Type'] = 'application/json';
      await http.post(
        Uri.parse('${ApiConstants.baseUrl}/notifications/mark-read'),
        headers: headers,
        body: jsonEncode({'ids': ids}),
      );
      await fetchNotifications();
    } catch (_) {}
  }

  Future<void> markAllRead() async {
    try {
      final headers = await _authHeaders();
      headers['Content-Type'] = 'application/json';
      await http.post(
        Uri.parse('${ApiConstants.baseUrl}/notifications/mark-all-read'),
        headers: headers,
      );
      await fetchNotifications();
    } catch (_) {}
  }

  void startPolling() {
    _timer?.cancel();
    fetchNotifications();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      fetchUnreadCount();
    });
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}

final NotificationService notificationService = NotificationService();
