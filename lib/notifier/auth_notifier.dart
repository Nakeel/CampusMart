import 'dart:collection';

import 'package:campus_mart/models/user_info.dart';
import 'package:flutter/cupertino.dart';

class AuthNotifier with ChangeNotifier {
  CustomUserInfo _userDoc ;


  CustomUserInfo get userDoc => _userDoc;

  set userDoc(CustomUserInfo userDoc ) {
    _userDoc = userDoc;
    notifyListeners();
  }

}
