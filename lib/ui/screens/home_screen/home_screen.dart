import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:law_enforcement/data/constants/globals.dart';
import 'package:law_enforcement/data/router/app_state.dart';
import 'package:law_enforcement/logic/provider/home_provider.dart';
import 'package:provider/provider.dart';

import '../../../data/model/user_model.dart';
import '../../../data/router/models/page_action.dart';
import '../../../data/router/models/page_config.dart';
import '../../../data/router/models/page_state_enum.dart';
import '../../../logic/provider/user_provider.dart';
import '../../../logic/services/pushnotification_services.dart';
import '../alarm_screen/google_map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoadingCheck = false;
  bool isSafeLoadingCheck = false;
  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Law Enforcement'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Are you sure you want to logout?',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Yes'),
                onPressed: () async {
                  // print(context.read<UserProvider>().loggedInUserModal!.userId.toString());
                  await context.read<UserProvider>().logout(context);
                  // context.read<HomeProvider>().setIsAlarmPressed();
                },
              ),
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  print('Cancel');
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> getEmergencyHelpList() async {
    setState(() {
      isLoadingCheck = true;
    });

    var url = 'https://qa-er-notificationapi';
    if (!await InternetConnectionChecker().hasConnection) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No Internet'),
        duration: Duration(milliseconds: 500),
      ));
      setState(() {
        isLoadingCheck = false;
      });
    } else {
      try {
        http.Response response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        if (response.statusCode == 200) {
          var getDataFromJsonResponse = jsonDecode(response.body);

          for (var item in getDataFromJsonResponse) {
            var userValue = UserModel.fromJson(item);
            context.read<UserProvider>().addUser(context, userValue);
          }
          print('aftab');
          print(getDataFromJsonResponse);
          setState(() {
            isLoadingCheck = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Something went wrong'),
            duration: Duration(milliseconds: 500),
          ));
          setState(() {
            isLoadingCheck = false;
          });
        }
      } catch (e) {
        setState(() {
          isLoadingCheck = false;
        });
        print(e.toString());
      }
    }
  }

  bool _isExecuting = false;
  void debounce(Function action) async {
    if (!_isExecuting) {
      _isExecuting = true;
      action();
      await Future.delayed(const Duration(milliseconds: 500), () {
        _isExecuting = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getEmergencyHelpList();
    // PushNotificationService.setContext(context);

    setNotifications();
    PushNotificationService().checkNewStartApp();
  }

  setNotifications() async {
    print('hhhhhh');
    // PushNotificationService.context = context;
    await PushNotificationService().initialize();
    print('hhhhhh2');
    FirebaseMessaging.onBackgroundMessage(PushNotificationService.backgroundHandler);
  }

  UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () async {
                // print(PushNotificationService.context);
                // FlutterRingtonePlayer.play(fromAsset: "assets/alarm.mp3", looping: false);
                // return;

                _showLogoutDialog();
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ))
        ],
        title: const Text('Law Enforcement'),
      ),
      body: SafeArea(
          child: Center(
              child: isLoadingCheck
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Consumer<UserProvider>(builder: (context, provider, ch) {
                      if (provider.users.isEmpty) {
                        return const Center(
                          child: Text('No users found'),
                        );
                      }
                      return ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: provider.users.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Card(
                              child: SizedBox(
                                height: 120.h,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(provider.users[i].branchName),
                                        Text(provider.users[i].bankName),
                                        Text(provider.users[i].name),
                                        Text(provider.users[i].branchAddress),
                                        provider.users[i].status == 'Responded'
                                            ? ElevatedButton(
                                                onPressed: () {
                                                  context.read<HomeProvider>().setIsAlarmPressed();
                                                  print(context.read<HomeProvider>().isResponded);
                                                },
                                                style: ElevatedButton.styleFrom(primary: Colors.green),
                                                child: const Text('Responded'),
                                              )
                                            : ElevatedButton(
                                                onPressed: () {
                                                  lat = provider.users[i].lat;
                                                  lng = provider.users[i].lng;
                                                  context.read<HomeProvider>().setIsAlarmPressed();
                                                  AppState appState = sl();
                                                  appState.currentAction = PageAction(
                                                      state: PageState.addWidget,
                                                      page: PageConfigs.googleMapPageConfig,
                                                      widget: MapScreen(
                                                        lat: provider.users[i].lat,
                                                        lng: provider.users[i].lng,
                                                        address: provider.users[i].branchAddress,
                                                        bankName: provider.users[i].bankName,
                                                        branchName: provider.users[i].branchName,
                                                        eId: provider.users[i].userId,
                                                      ));

                                                  print(context.read<HomeProvider>().isResponded);
                                                },
                                                style: ElevatedButton.styleFrom(primary: Colors.red),
                                                child: const Text('Pending'),
                                              )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }))),
    );
  }
}
