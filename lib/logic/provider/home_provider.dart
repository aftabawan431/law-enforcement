import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  bool isResponded = false;

  setIsAlarmPressed() {
    isResponded = !isResponded;
    notifyListeners();
  }
}
