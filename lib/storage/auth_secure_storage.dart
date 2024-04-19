import 'package:finia_app/responses/userResponse.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class TokenStorage {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<void> saveToken(String token, String refreshToken) async {
    await storage.write(key: 'token', value: token);
    await storage.write(key: 'refreshToken', value: refreshToken);
  }

  Future<String?> getToken() async {
    return storage.read(key: 'token');
  }

  Future<String?> getRefreshToken() async {
    return storage.read(key: 'refreshToken');
  }

  Future<void> deleteAllTokens() async {
    await storage.deleteAll();
  }

  Future<void> saveUser(UserAuth user) async {
    final String userData = jsonEncode(user.toJson());
    await storage.write(key: 'user', value: userData);
  }

  Future<UserAuth?> getUser() async {
    final String? userData = await storage.read(key: 'user');
    if (userData != null) {
      return UserAuth.fromJson(jsonDecode(userData));
    }
    return null;
  }

  // You may also want to implement a deleteUser method if needed
  Future<void> deleteUser() async {
    await storage.delete(key: 'user');
  }
}
