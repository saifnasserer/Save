import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:save/providers/notification_provider.dart';

class Memo {
  final int? id;
  final String title;
  final String? content;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final bool isPinned;
  final String? category;

  Memo({
    this.id,
    required this.title,
    this.content,
    DateTime? createdAt,
    DateTime? modifiedAt,
    this.isPinned = false,
    this.category,
  })  : createdAt = createdAt ?? DateTime.now(),
        modifiedAt = modifiedAt ?? DateTime.now();

  // Create from map (database)
  factory Memo.fromMap(Map<String, dynamic> map) {
    return Memo(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      modifiedAt: DateTime.parse(map['modified_at'] as String),
      isPinned: (map['is_pinned'] as int) == 1,
      category: map['category'] as String?,
    );
  }

  // Convert to map (database)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'modified_at': modifiedAt.toIso8601String(),
      'is_pinned': isPinned ? 1 : 0,
      'category': category,
    };
  }

  // Create a copy with some fields updated
  Memo copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? modifiedAt,
    bool? isPinned,
    String? category,
  }) {
    return Memo(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      isPinned: isPinned ?? this.isPinned,
      category: category ?? this.category,
    );
  }
}

class MemoItem extends StatefulWidget {
  final int? id;
  final String title;
  final String? content;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final bool isPinned;
  final String? category;
  final VoidCallback? onTap;
  final Function(DateTime)? onNotificationSet;
  final Function()? onDelete;
  final Function(bool)? onPinChanged;

  const MemoItem({
    super.key,
    this.id,
    required this.title,
    this.content,
    required this.createdAt,
    required this.modifiedAt,
    this.isPinned = false,
    this.category,
    this.onTap,
    this.onNotificationSet,
    this.onDelete,
    this.onPinChanged,
  });

  // Convert from Memo model
  factory MemoItem.fromMemo(Memo memo) {
    return MemoItem(
      id: memo.id,
      title: memo.title,
      content: memo.content,
      createdAt: memo.createdAt,
      modifiedAt: memo.modifiedAt,
      isPinned: memo.isPinned,
      category: memo.category,
    );
  }

  // Convert to Memo model
  Memo toMemo() {
    return Memo(
      id: id,
      title: title,
      content: content,
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      isPinned: isPinned,
      category: category,
    );
  }

  // Create a copy with some fields updated
  MemoItem copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? modifiedAt,
    bool? isPinned,
    String? category,
    VoidCallback? onTap,
    Function(DateTime)? onNotificationSet,
    Function()? onDelete,
    Function(bool)? onPinChanged,
  }) {
    return MemoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      isPinned: isPinned ?? this.isPinned,
      category: category ?? this.category,
      onTap: onTap ?? this.onTap,
      onNotificationSet: onNotificationSet ?? this.onNotificationSet,
      onDelete: onDelete ?? this.onDelete,
      onPinChanged: onPinChanged ?? this.onPinChanged,
    );
  }

  @override
  State<MemoItem> createState() => _MemoItemState();
}

class _MemoItemState extends State<MemoItem> {
  bool _hasNotifications = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    if (widget.id == null) return;
    
    final notifications =
        await Provider.of<NotificationProvider>(context, listen: false)
            .getNotificationsForMemo(widget.id!);
    if (mounted) {
      setState(() {
        _hasNotifications = notifications.isNotEmpty;
      });
    }
  }

  Future<void> _showDateTimePicker() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return;

    if (!mounted) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    if (!mounted) return;

    final DateTime notificationTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    widget.onNotificationSet?.call(notificationTime);
    _loadNotifications(); // Reload notifications after setting a new one
  }

  void _showMenuOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                widget.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: Colors.grey[600],
              ),
              title: Text(widget.isPinned ? 'Unpin memo' : 'Pin memo'),
              onTap: () {
                widget.onPinChanged?.call(!widget.isPinned);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete memo',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                widget.onDelete?.call();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, y • h:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black12.withOpacity(.05),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(widget.modifiedAt),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  _hasNotifications ? Icons.notifications : Icons.notifications_none,
                  color: Colors.grey[600],
                ),
                onPressed: _showDateTimePicker,
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: _showMenuOptions,
                color: Colors.grey[600],
              ),
              if (widget.isPinned)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.push_pin, size: 16, color: Colors.amber[700]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
