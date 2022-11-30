import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get_it/get_it.dart';
import 'package:law_enforcement/data/model/notification_model.dart';
import 'package:law_enforcement/ui/screens/alarm_screen/google_map_screen.dart';

import '../../data/router/app_state.dart';
import '../../data/router/models/page_action.dart';
import '../../data/router/models/page_config.dart';
import '../../data/router/models/page_state_enum.dart';

// GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

late BuildContext pushNotiContext;
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class PushNotificationService {
  static bool canInitWork = false;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future initialize() async {
    await FirebaseMessaging.instance.getToken();
    var initialzationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? payload) {
      if (payload != null) {
        var decodedPayload = jsonDecode(payload);
        var notifier = NotificationModel(
            emergencyID: decodedPayload['emergencyID'],
            branchName: decodedPayload['branchName'],
            clickaction: decodedPayload['clickaction'],
            statusMessage: decodedPayload['statusMessage'],
            statusCode: decodedPayload['statusCode'],
            address: decodedPayload['address'],
            bankName: decodedPayload['bankName'],
            Lat: decodedPayload['Lat'],
            Lng: decodedPayload['Lng'],
            managerName: decodedPayload['managerName']);
        manageNotification(notifier);
      }
    });
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    // FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      // var noti = getNotificationData(message);

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        var notifier = getNotificationData(message);
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
              ),
            ),
            payload: jsonEncode(notifier?.toJson()));
      }

      var noti = getNotificationData(message);
      print(noti!.toJson());
      if (notification != null) {
        manageNotification(noti);
      }
    });

    // FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('open message is triggered');
      print('Got a message on opened app!');
      print(message);
      print(message.data);
      var notification = getNotificationData(message);
      print(notification!.toJson());
      if (notification != null) {
        manageNotification(notification);
      }

      // var noti = getNotificationData(message);
    });
    print("this 2");
  }

  static manageNotification(NotificationModel notification) {
    print(notification.toJson());
    print("Hello");
    // print(context);
    // Navigator.of(pushNotiContext).push(MaterialPageRoute(builder: (_) => MapScreen()));
    AppState appState = GetIt.I.get<AppState>();

    FlutterRingtonePlayer.play(fromAsset: "assets/alarm.mp3", looping: false);

    appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: PageConfigs.googleMapPageConfig,
        widget: MapScreen(
          lat: notification.Lat,
          lng: notification.Lng,
          address: notification.address,
          bankName: notification.bankName,
          branchName: notification.branchName,
          eId: notification.emergencyID,
        ));
  }

  static NotificationModel? getNotificationData(message) {
    if (Platform.isAndroid) {
      return NotificationModel.fromJson(message.data);
    } else if (Platform.isIOS) {
      return NotificationModel.fromJson(message);
    } else {
      return null;
    }
  }

  // static FCMNotiModal getNotificationData(message) {
  //   late FCMNotiModal notificationModal;

  //   if (Platform.isAndroid) {
  //     notificationModal = FCMNotiModal(
  //       supportId: message.data['sId'],
  //       type: message.data['type'],
  //     );
  //   } else {
  //     notificationModal = FCMNotiModal(
  //       supportId: message['sId'],
  //       type: message['type'],
  //     );
  //   }
  //   return notificationModal;
  // }

  static Future<void> backgroundHandler(RemoteMessage message) async {
    print('got a message on app in backgorund');
    // canInitWork = true;
    // await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
    print('Message data: ${message.data}');
    var notification = getNotificationData(message);
    print(notification!.toJson());
    if (notification != null) {
      // manageNotification(notification);
    }
  }

  Future<String?> getToken() async {
    String? token = await firebaseMessaging.getToken();

    return token;
  }

  void checkNewStartApp() {
    firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      print('done it man');
      print(message);
      if (message != null) {
        var noti = PushNotificationService.getNotificationData(message);
        if (noti != null) {
          PushNotificationService.manageNotification(noti);
        }
      }
      if (PushNotificationService.canInitWork) {}
    });
  }
}
