import 'dart:convert';

import 'package:law_enforcement/data/model/user_model.dart';
import 'package:law_enforcement/logic/services/secure_storage_service.dart';

import '../../data/constants/globals.dart';

class UserService {
  SecureStorageService _storageService = sl();

  Future<List<UserModel>> getAllUsers() async {
    final result = await _storageService.read(key: 'users');
    if (result == null) {
      return [];
    } else {
      final decodedUsers = jsonDecode(result);
      return decodedUsers.map<UserModel>((item) => UserModel.fromJson(item)).toList();
    }
  }

  Future<void> updateAllUsers({required List<UserModel> list}) async {
    await _storageService.write(key: 'users', value: jsonEncode(list.map((e) => e.toJson()).toList()));
  }
}
