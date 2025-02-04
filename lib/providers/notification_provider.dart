import 'package:flutter/material.dart';
import 'package:save/Screens/notifs.dart';
import 'package:save/models/memo.dart';
import 'package:save/services/database/database_service.dart';

class NotificationProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<MemoNotification> _notifications = [];
  bool _isLoading = false;
  String? _error;

  List<MemoNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all notifications
  Future<void> loadNotifications() async {
    _setLoading(true);
    try {
      _notifications = await _db.getAllNotifications();
      _error = null;
    } catch (e) {
      _error = 'Failed to load notifications: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Create new notification
  Future<void> createNotification(Memo memo, DateTime notificationTime) async {
    try {
      final notification = MemoNotification(
        id: 0, // Will be set by database
        memo: memo,
        notificationTime: notificationTime,
      );

      await _db.createNotification(notification);
      await loadNotifications(); // Reload to get the updated list
      _error = null;
    } catch (e) {
      _error = 'Failed to create notification: $e';
      Future.microtask(() => notifyListeners());
    }
  }

  // Delete notification
  Future<void> deleteNotification(int id) async {
    try {
      await _db.deleteNotification(id);
      _notifications.removeWhere((n) => n.id == id);
      _error = null;
      Future.microtask(() => notifyListeners());
    } catch (e) {
      _error = 'Failed to delete notification: $e';
      Future.microtask(() => notifyListeners());
    }
  }

  // Mark notification as completed
  Future<void> completeNotification(int id) async {
    try {
      await _db.completeNotification(id);
      _notifications.removeWhere((n) => n.id == id);
      _error = null;
      Future.microtask(() => notifyListeners());
    } catch (e) {
      _error = 'Failed to complete notification: $e';
      Future.microtask(() => notifyListeners());
    }
  }

  // Get notifications for a specific memo
  Future<List<MemoNotification>> getNotificationsForMemo(int memoId) async {
    try {
      return await _db.getNotificationsForMemo(memoId);
    } catch (e) {
      _error = 'Failed to get notifications for memo: $e';
      Future.microtask(() => notifyListeners());
      return [];
    }
  }

  void _setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    Future.microtask(() => notifyListeners());
  }
}
