import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save/Screens/home.dart';
import 'package:save/Screens/memos.dart';
import 'package:save/Screens/new_memo.dart';
import 'package:save/providers/memo_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MemoProvider()),
      ],
      child: const Save(),
    ),
  );
}

class Save extends StatelessWidget {
  const Save({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        Memo.ID: (context) => Memo(),
        NewMemo.ID: (context) => NewMemo(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          bodyMedium:
              TextStyle(fontWeight: FontWeight.w500), // Medium as default
        ),
      ),
      home: Home(),
    );
  }
}
