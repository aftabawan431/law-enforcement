import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:law_enforcement/logic/provider/user_provider.dart';
import 'package:law_enforcement/logic/services/auth_service.dart';
import 'package:law_enforcement/logic/services/user_services.dart';
import 'package:provider/provider.dart';

import '../../data/constants/globals.dart';
import '../../data/model/user_model.dart';
import '../../data/router/app_state.dart';
import '../../data/router/models/page_action.dart';
import '../../data/router/models/page_config.dart';
import '../../data/router/models/page_state_enum.dart';
import '../../logic/local_data_source.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    goToScreen();
    // setNotifications();
  }

  AppState appState = GetIt.I.get<AppState>();
  final LocalDataSource localDataSource = sl();
  final AuthServices _authServices = sl();
  final UserService _userServices = sl();

  goToScreen() async {
    Timer(const Duration(milliseconds: 200), () async {
      LoggedInUserModel? user = await _authServices.checkIfUserLoggedIn();

      if (user != null) {
        context.read<UserProvider>().setLoggedInUser(user);

        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
        appState.currentAction = PageAction(state: PageState.replace, page: PageConfigs.homePageConfig);
      } else {
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
        appState.currentAction = PageAction(state: PageState.replace, page: PageConfigs.loginPageConfig);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
