import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save/Screens/new_memo.dart';
import 'package:save/models/memo.dart';
import 'package:save/providers/memo_provider.dart';

class Memo extends StatefulWidget {
  const Memo({super.key});
  static String ID = 'memoid';
  @override
  State<Memo> createState() => MemoState();
}

class MemoState extends State<Memo> {
  @override
  Widget build(BuildContext context) {
    var memosBank = Provider.of<MemoProvider>(context).memosBank;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: memosBank.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                reverse: true,
                itemCount: memosBank.length,
                itemBuilder: (context, index) {
                  return MemoItem(
                    title: memosBank[index].title,
                  );
                },
              )
            : SizedBox.shrink(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff111111),
        onPressed: () {
          Navigator.pushNamed(context, NewMemo.ID);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
