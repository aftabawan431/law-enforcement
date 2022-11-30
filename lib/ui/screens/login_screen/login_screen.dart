import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:law_enforcement/logic/services/pushnotification_services.dart';
import 'package:law_enforcement/logic/services/secure_storage_service.dart';
import 'package:law_enforcement/logic/services/validators.dart';
import 'package:law_enforcement/ui/widgets/custom_buttton.dart';
import 'package:law_enforcement/ui/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

import '../../../data/constants/globals.dart';
import '../../../data/model/user_model.dart';
import '../../../data/router/app_state.dart';
import '../../../data/router/models/page_action.dart';
import '../../../data/router/models/page_config.dart';
import '../../../data/router/models/page_state_enum.dart';
import '../../../logic/provider/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  PushNotificationService pushNotificationService = PushNotificationService();
  AppState appState = GetIt.I.get<AppState>();

  String mobile = '';
  String pin = '';
  Validators validators = Validators();

  // final AuthServices _authServices = AuthServices();

  bool isLoadingCheck = false;
  // @override
  // void initState() {
  //   super.initState();
  //   pushNotificationService.checkNewStartApp();
  // }

  Future<void> loginUser() async {
    setState(() {
      isLoadingCheck = true;
    });
    final fcmToken = await pushNotificationService.getToken();
    var loginJsonBody = jsonEncode(<String, String>{
      'phoneNo': mobile.toString(),
      'password': pin.toString(),
      "fcmToken": fcmToken.toString(),
    });
    print(loginJsonBody);
    var url = 'https://qa-er-notificationapi.appinsnap.com/api/ChannelUsers/Login';
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
          body: loginJsonBody,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        if (response.statusCode == 200) {
          var getDataFromJsonResponse = jsonDecode(response.body);
          context.read<UserProvider>().setLoggedInUser(LoggedInUserModel.fromJson(getDataFromJsonResponse));

          SecureStorageService _secureStore = sl();
          await _secureStore.write(key: 'user', value: jsonEncode(getDataFromJsonResponse));

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Login Successful'),
            duration: Duration(milliseconds: 500),
          ));
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute<void>(
          //     builder: (BuildContext context) => const HomeScreen(),
          //   ),
          // );
          appState.currentAction = PageAction(state: PageState.addPage, page: PageConfigs.homePageConfig);

          setState(() {
            isLoadingCheck = false;
          });
        } else {
          if (response.statusCode == 400) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Mobile or Pin is invalid'),
              duration: Duration(milliseconds: 500),
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Something went wrong'),
              duration: Duration(milliseconds: 500),
            ));
          }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Law Enforcement',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.red),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  TextFieldWidget(
                      isPhone: true,
                      hint: 'Mobile',
                      digitsOnly: true,
                      maxLength: 11,
                      onChanged: (value) {
                        mobile = value!;
                      },
                      validator: validators.validateMobile),
                  TextFieldWidget(
                      hint: 'Password',
                      // isNumber: true,
                      // isPhone: true,
                      // digitsOnly: true,
                      maxLength: 10,
                      onChanged: (value) {
                        pin = value!;
                      },
                      validator: validators.validatePin),
                  isLoadingCheck
                      ? const CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.red,
                        )
                      : ElevatedButtonWidget(
                          title: 'Login',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              loginUser();
                            }
                          })
                ],
              ),
            )),
      ),
    );
  }
}
