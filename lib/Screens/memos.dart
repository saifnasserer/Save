import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save/Screens/edit_memo.dart';
import 'package:save/Screens/new_memo.dart';
import 'package:save/models/memo.dart';
import 'package:save/providers/memo_provider.dart';
import 'package:save/providers/notification_provider.dart';

class Memo extends StatefulWidget {
  static String ID = 'memos';

  const Memo({super.key});

  @override
  State<Memo> createState() => _MemoState();
}

class _MemoState extends State<Memo> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    Provider.of<MemoProvider>(context, listen: false).loadMemos();
  }

  void _handleNotificationSet(MemoItem memo, DateTime notificationTime) {
    final memoProvider = Provider.of<MemoProvider>(context, listen: false);
    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    memoProvider.setNotification(
        context, memo, notificationTime, notificationProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search memos...',
                  border: InputBorder.none,
                ),
                onChanged: (query) {
                  if (query.isNotEmpty) {
                    Provider.of<MemoProvider>(context, listen: false)
                        .searchMemos(query);
                  } else {
                    Provider.of<MemoProvider>(context, listen: false)
                        .loadMemos();
                  }
                },
                autofocus: true,
              )
            : const Text('Memos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  Provider.of<MemoProvider>(context, listen: false).loadMemos();
                }
              });
            },
          ),
        ],
      ),
      body: Consumer<MemoProvider>(
        builder: (context, memoProvider, child) {
          if (memoProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (memoProvider.error != null) {
            return Center(
              child: Text(
                'Error: ${memoProvider.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final memos = memoProvider.memosBank;
          if (memos.isEmpty) {
            return const Center(
              child: Text(
                'No memos yet.\nTap + to create one!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView.builder(
              reverse: true,
              shrinkWrap: true,
              itemCount: memos.length,
              itemBuilder: (context, index) {
                final memo = memos[index];
                return MemoItem(
                  id: memo.id,
                  title: memo.title,
                  content: memo.content,
                  createdAt: memo.createdAt,
                  modifiedAt: memo.modifiedAt,
                  isPinned: memo.isPinned,
                  category: memo.category,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditMemo(memo: memo),
                      ),
                    );
                  },
                  onNotificationSet: (dateTime) =>
                      _handleNotificationSet(memo, dateTime),
                  onDelete: () => memoProvider.deleteMemo(memo),
                  onPinChanged: (isPinned) async {
                    final updatedMemo = memo.copyWith(isPinned: isPinned);
                    await memoProvider.updateMemo(updatedMemo);
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, NewMemo.ID);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
