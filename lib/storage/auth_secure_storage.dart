import 'package:finia_app/responses/userResponse.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class TokenStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> saveToken(String? accessToken, String? refreshToken) async {
    if (accessToken != null) {
      await storage.write(key: 'accessToken', value: accessToken);
    }
    if (refreshToken != null) {
      await storage.write(key: 'refreshToken', value: refreshToken);
    }
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: 'accessToken');
  }

  /// Retrieves the refresh token.
  Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refreshToken');
  }

  /// Deletes all tokens and user data.
  Future<void> deleteAllTokens() async {
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'refreshToken');
    await storage.delete(key: 'user');
  }

  Future<void> saveUser(UserAuth user) async {
    final String userData = jsonEncode(user.toJson());
    await storage.write(key: 'user', value: userData);
  }

  /// Loads the user data securely.
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
