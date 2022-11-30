import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_enforcement/data/constants/colors.dart';
import 'package:law_enforcement/logic/provider/home_provider.dart';
import 'package:law_enforcement/logic/provider/user_provider.dart';
import 'package:provider/provider.dart';

import 'data/constants/globals.dart';
import 'data/router/uremit_back_button_dispatcher.dart';
import 'data/router/uremit_router_delegate.dart';
import 'data/router/uremit_router_parser.dart';
import 'dependency_injection.dart' as dl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dl.init();
  await Firebase.initializeApp();

  runApp(
    DevicePreview(
      builder: (context) => const MyApp(),
      enabled: false,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late CWBaluchistanRouterDelegate delegate;
  late UremitBackButtonDispatcher backButtonDispatcher;
  late CWBaluchistanRouterParser parser = CWBaluchistanRouterParser();

  @override
  void initState() {
    delegate = CWBaluchistanRouterDelegate(sl());
    backButtonDispatcher = UremitBackButtonDispatcher(sl());
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: ScreenUtilInit(
          designSize: const Size(360, 804),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, ch) {
            // pushNotiContext = context;
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: MaterialApp.router(
                // navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                title: 'Law Enforcement',
                theme: ThemeData(
                  primaryColor: kPrimaryColor,
                  primarySwatch: Colors.red,
                ),
                routerDelegate: delegate,
                backButtonDispatcher: backButtonDispatcher,
                routeInformationParser: parser,
              ),
            );
          }),
    );
  }
}
