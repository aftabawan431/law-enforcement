import 'dart:convert';

import 'package:law_enforcement/data/model/user_model.dart';
import 'package:law_enforcement/logic/services/secure_storage_service.dart';

import '../data/constants/secure_storage_keys.dart';

abstract class LocalDataSource {
  Future<List<UserModel>> getAllUsers();
}

class LocalDataSourceImg implements LocalDataSource {
  final SecureStorageService _secureStorageService = SecureStorageService();

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      final result = await _secureStorageService.read(key: SecureStorageKeys.Users_Key);
      if (result != null) {
        return [];
      } else {
        final jsonResponse = jsonDecode(result!);
        return jsonResponse.map((item) => UserModel.fromJson(item)).toList();
      }
    } catch (e) {
      return [];
    }
  }
}
