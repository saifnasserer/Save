import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MemoItem extends StatefulWidget {
  final String title;
  final DateTime createdAt;

  MemoItem({
    super.key,
    required this.title,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  @override
  State<MemoItem> createState() => _MemoItemState();
}

class _MemoItemState extends State<MemoItem> {
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
          onPressed: () {},
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
                        _formatDate(widget.createdAt),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.notifications_none)),
                IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
              ],
            ),
          )),
    );
  }
}
