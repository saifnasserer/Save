import 'package:flutter/material.dart';
import 'package:save/models/memo.dart';
import 'package:save/providers/notification_provider.dart';
import 'package:save/services/database/database_service.dart';

class MemoProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<MemoItem> _memosBank = [];
  bool _isLoading = false;
  String? _error;

  List<MemoItem> get memosBank {
    final sortedMemos = List<MemoItem>.from(_memosBank);
    sortedMemos.sort((a, b) {
      // First sort by pin status
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      
      // Then sort by modified date (most recent first)
      return b.modifiedAt.compareTo(a.modifiedAt);
    });
    return sortedMemos;
  }

  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all memos from database
  Future<void> loadMemos() async {
    _setLoading(true);
    try {
      final memos = await _db.getAllMemos();
      _memosBank = memos.map((m) => MemoItem.fromMemo(m)).toList();
      _error = null;
    } catch (e) {
      _error = 'Failed to load memos: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Add new memo
  Future<void> addMemo(MemoItem memo) async {
    _setLoading(true);
    try {
      final newMemo = await _db.insertMemo(memo.toMemo());
      _memosBank.add(memo);
      _error = null;
    } catch (e) {
      _error = 'Failed to add memo: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Update existing memo
  Future<void> updateMemo(MemoItem memo) async {
    try {
      final updatedMemo = memo.copyWith(modifiedAt: DateTime.now());
      await _db.updateMemo(updatedMemo.toMemo());
      final index = _memosBank.indexWhere((m) => m.id == memo.id);
      if (index != -1) {
        _memosBank[index] = updatedMemo;
      }
      _error = null;
      Future.microtask(() => notifyListeners());
    } catch (e) {
      _error = 'Failed to update memo: $e';
      Future.microtask(() => notifyListeners());
    }
  }

  // Delete memo
  Future<void> deleteMemo(MemoItem memo) async {
    try {
      await _db.deleteMemo(memo.id!);
      _memosBank.removeWhere((m) => m.id == memo.id);
      _error = null;
      Future.microtask(() => notifyListeners());
    } catch (e) {
      _error = 'Failed to delete memo: $e';
      Future.microtask(() => notifyListeners());
    }
  }

  // Search memos
  Future<void> searchMemos(String query) async {
    _setLoading(true);
    try {
      final memos = await _db.searchMemos(query);
      _memosBank = memos.map((m) => MemoItem.fromMemo(m)).toList();
      _error = null;
    } catch (e) {
      _error = 'Failed to search memos: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Set notification for memo
  Future<void> setNotification(
      BuildContext context,
      MemoItem memo,
      DateTime notificationTime,
      NotificationProvider notificationProvider) async {
    try {
      await notificationProvider.createNotification(
          memo.toMemo(), notificationTime);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notification set for ${memo.title}')),
        );
      }
    } catch (e) {
      _error = 'Failed to set notification: $e';
      Future.microtask(() => notifyListeners());
    }
  }

  void _setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    Future.microtask(() => notifyListeners());
  }
}
