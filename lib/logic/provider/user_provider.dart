import 'package:flutter/material.dart';
import 'package:law_enforcement/data/model/user_model.dart';
import 'package:law_enforcement/logic/services/app_services.dart';
import 'package:law_enforcement/logic/services/auth_service.dart';
import 'package:law_enforcement/logic/services/user_services.dart';

import '../../data/constants/globals.dart';
import '../../data/router/app_state.dart';
import '../../data/router/models/page_action.dart';
import '../../data/router/models/page_config.dart';
import '../../data/router/models/page_state_enum.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> _users = [];
  List<UserModel> get users => _users.toList();
  UserModel? _currentUser;
  LoggedInUserModel? loggedInUserModal;
  UserModel? get currentUser => _currentUser;
  UserService _userService = sl();
  AuthServices _authServices = sl();
  String status = 'active';

  Future getAndSetAllUsers() async {
    final usersRes = await _userService.getAllUsers();
    _users = usersRes;
    notifyListeners();
  }

  Future updateUser(BuildContext context, UserModel userModal) async {
    int index = _users.indexWhere((element) => element.userId == userModal.userId);
    _users[index] = userModal;
    updateAllUsersOnDisk();
    notifyListeners();
    Navigator.of(context).pop();
    AppServices.showSnackeBar(context, 'User updated');
  }

  Future updateAllUsersOnDisk() async {
    await _userService.updateAllUsers(list: users);
  }

  //current users functions
  void setCurrentUser(UserModel? value) {
    _currentUser = value;
    notifyListeners();
  }

  // manage users
  void setUsers(List<UserModel> list) {
    _users = list;
    notifyListeners();
  }

  void addUser(BuildContext context, UserModel userModal) {
    _users.add(userModal);
    notifyListeners();
  }

  Future logout(BuildContext context) async {
    _authServices.logoutUser(context);
    AppState appState = sl();
    appState.currentAction = PageAction(state: PageState.replaceAll, page: PageConfigs.loginPageConfig);

    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
  }

  void setLoggedInUser(LoggedInUserModel? value) {
    loggedInUserModal = value;
    notifyListeners();
  }
}
