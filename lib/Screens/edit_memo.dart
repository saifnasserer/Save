import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save/models/memo.dart';
import 'package:save/providers/memo_provider.dart';

class EditMemo extends StatefulWidget {
  static String ID = 'edit_memo';
  final MemoItem memo;

  const EditMemo({super.key, required this.memo});

  @override
  State<EditMemo> createState() => _EditMemoState();
}

class _EditMemoState extends State<EditMemo> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late MemoItem _currentMemo;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _currentMemo = widget.memo;
    _titleController = TextEditingController(text: _currentMemo.title);
    _contentController = TextEditingController(text: _currentMemo.content);

    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (!_hasChanges &&
        (_titleController.text != _currentMemo.title ||
            _contentController.text != _currentMemo.content)) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTextChanged);
    _contentController.removeListener(_onTextChanged);
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return false;
    }

    try {
      final updatedMemo = _currentMemo.copyWith(
        title: _titleController.text,
        content: _contentController.text,
        modifiedAt: DateTime.now(),
      );

      await Provider.of<MemoProvider>(context, listen: false)
          .updateMemo(updatedMemo);

      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save memo: $e')),
        );
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _titleController,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter title',
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _onWillPop()) {
                if (mounted) Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last modified: ${_formatDateTime(_currentMemo.modifiedAt)}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter memo content',
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(dateTime.day)}/${twoDigits(dateTime.month)}/${dateTime.year} ${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}';
  }
}
