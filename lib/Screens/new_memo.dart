import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save/models/memo.dart';
import 'package:save/providers/memo_provider.dart';

class NewMemo extends StatefulWidget {
  const NewMemo({super.key});
  static String ID = 'NewmemoID';

  @override
  State<NewMemo> createState() => _NewMemoState();
}

class _NewMemoState extends State<NewMemo> {
  final TextEditingController _memoController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _memoController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var memoProvider = Provider.of<MemoProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            if (_titleController.text.isNotEmpty &&
                _memoController.text.isNotEmpty) {
              memoProvider.addMemo(
                MemoItem(
                  title: _titleController.text,
                  createdAt: DateTime.now(),
                ),
              );
            }
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Title',
              contentPadding: EdgeInsets.all(16.0),
              border: InputBorder.none,
              alignLabelWithHint: true,
            ),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            textCapitalization: TextCapitalization.words,
          ),
          Expanded(
            child: TextField(
              controller: _memoController,
              decoration: const InputDecoration(
                hintText: 'Enter your memo...',
                contentPadding: EdgeInsets.all(16.0),
                border: InputBorder.none,
                alignLabelWithHint: true,
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              textAlign: TextAlign.center,
              expands: true,
            ),
          ),
        ],
      ),
    );
  }
}
