import 'dart:collection';

import 'package:campus_mart/models/wants_data.dart';
import 'package:flutter/cupertino.dart';

class WantsNotifier with ChangeNotifier {
  List<Wants> _wantList = [];
  Wants _currentWant;

  UnmodifiableListView<Wants> get wantList => UnmodifiableListView(_wantList);

  Wants get currentWants => _currentWant;

  set wantList(List<Wants> wantList) {
    _wantList = wantList;
    notifyListeners();
  }

  set currentFood(Wants wants) {
    _currentWant = wants;
    notifyListeners();
  }
}
