import 'package:flutter/material.dart';
import 'package:save/Screens/memos.dart';
import 'package:save/models/box.dart';
import 'package:save/models/user.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            User(path: 'assets/characters/workingman.png'),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hello,',
                    style: TextStyle(fontSize: 25, color: Colors.grey[600]),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Saif',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                HomeItem(
                    path: 'assets/Icons/file.png',
                    data: 'Memos',
                    ontap: () {
                      Navigator.pushNamed(context, Memo.ID);
                    }),
                HomeItem(
                    path: 'assets/Icons/yes.png', data: 'Todo', ontap: () {}),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                HomeItem(
                  path: 'assets/Icons/play.png',
                  data: 'Voice',
                  ontap: () {},
                ),
                HomeItem(
                  path: 'assets/Icons/yes.png',
                  data: 'Todo',
                  ontap: () {},
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                HomeItem(
                    path: 'assets/Icons/bell.png',
                    data: 'Private',
                    ontap: () {}),
                HomeItem(
                    path: 'assets/Icons/padlock.png',
                    data: 'Notifs',
                    ontap: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
