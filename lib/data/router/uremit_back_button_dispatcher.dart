import 'package:flutter/material.dart';

import 'app_state.dart';

class UremitBackButtonDispatcher extends RootBackButtonDispatcher {
  final AppState appState;

  UremitBackButtonDispatcher(this.appState) : super();

  @override
  Future<bool> didPopRoute() async {
    appState.moveToBackScreen();
    return true;
  }
}
