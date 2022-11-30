import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_enforcement/data/model/user_model.dart';
import 'package:law_enforcement/logic/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../../ui/screens/home_screen/home_screen.dart';
import 'secure_storage_service.dart';

class AuthServices {
  final _secureStorage = SecureStorageService();

  /// This method is to check if user is logged in or not, will return null if no user found
  Future<LoggedInUserModel?> checkIfUserLoggedIn() async {
    final result = await _secureStorage.read(key: 'user');
    if (result == null) {
      return null;
    } else {
      final map = jsonDecode(result);
      return LoggedInUserModel.fromJson(map);
    }
  }

  // This method will take email as input to check if the written email is registered on the app or not
  // Future<bool> validateUserAccount(BuildContext context, String email, String pin) async {
  //   if (email.toLowerCase() == 'admin@gmail.com' && pin == '1234') {
  //     return true;
  //   }
  //   final users = context.read<UserProvider>().users.where((element) => element.email.toLowerCase() == email);
  //
  //   return (users.isNotEmpty && pin == '1234' && users.first.isActive);
  // }

  //
  // / this method will perform following tasks
  // / it will check if email is admin mail
  // / then it will check if admin is registered if not then register otherwise store it as current user so we can remember a user is signed in
  // / if not an admin then store the normal user in secure_storage to check on app launch if it is there
  Future<void> loginUser(
    BuildContext context, {
    required String email,
  }) async {
    if (email.toLowerCase() == 'admin@gmail.com') {
      final admin = await _secureStorage.read(key: 'admin');

      if (admin == null) {
        // final newUser =
        //     UserModel(userId: DateTime.now().toString(), name: 'admin', cnic: 'Manager', email: 'admin@gmail.com', mobile: '03407853962', isActive: true, isAdmin: true, pin: '');

        // await _secureStorage.write(key: 'Manager', value: jsonEncode(newUser.toJson()));
        // await _secureStorage.write(key: 'user', value: jsonEncode(newUser.toJson()));
        // // setCurrentUser(context, newUser);
      } else {
        final user = UserModel.fromJson(jsonDecode(admin));
        await _secureStorage.write(key: 'user', value: jsonEncode(user.toJson()));
        setCurrentUser(context, user);
      }
    } else {
      final user = context.read<UserProvider>().users.firstWhere((element) => element.name == email);

      await _secureStorage.write(key: 'user', value: jsonEncode(user.toJson()));
      context.read<UserProvider>().setCurrentUser(user);
    }
  }

  // Future sendOtp(BuildContext context, String email) async {
  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => OtpScreen(email)));
  // }

  Future verifyPin(BuildContext context, String email) async {
    await loginUser(context, email: email);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen()), (Route<dynamic> route) => false);
  }

  Future<void> getAllUsers(BuildContext context) async {}
  setCurrentUser(BuildContext context, UserModel user) {
    context.read<UserProvider>().setCurrentUser(user);
  }

  Future<void> logoutUser(BuildContext context) async {
    _secureStorage.delete(key: 'user');
    context.read<UserProvider>().setLoggedInUser(null);
  }
}
