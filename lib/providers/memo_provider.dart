import 'package:flutter/material.dart';
import 'package:save/models/memo.dart';

class MemoProvider extends ChangeNotifier {
  List<MemoItem> memosBank = [];

  void addMemo(MemoItem memo) {
    memosBank.add(memo);
    notifyListeners();
  }

  void deleteMemo(MemoItem memo) {
    memosBank.remove(memo);
    notifyListeners();
  }
}
