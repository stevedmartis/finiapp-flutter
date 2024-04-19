import 'package:finia_app/models/createUserDTO.dart';
import 'package:finia_app/responses/userResponse.dart';
import 'package:finia_app/storage/auth_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;
  UserAuth? currentUser; // Almacena la información del usuario globalmente

  AuthService() {
    loadUserData();
    _listenAuthState();
  }

  Future<void> loadUserData() async {
    // Load user data from secure storage.
    currentUser = await tokenStorage.getUser();

    // Check if the user is already authenticated.
    if (currentUser != null) {
      isLogin = true;
      notifyListeners();
    }

    // Refresh the token if necessary.
    await refreshToken();
  }

  final TokenStorage tokenStorage = TokenStorage();

  Future<bool> refreshToken() async {
    String? refreshToken = await tokenStorage.getRefreshToken();

    if (refreshToken == null) {
      // No refresh token available; user needs to log in again.
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/user/refresh-access-token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        await tokenStorage.saveToken(data['accessToken'], data['refreshToken']);
        return true; // Token was refreshed successfully
      } else {
        // Handle error, token refresh failed
        return false;
      }
    } catch (e) {
      // Network error, parsing error, etc.
      return false;
    }
  }

  bool isLogin = false;
  bool get isAuthenticated => _user != null;
  User? get user => _user;
  UserAuth? get globalUser => currentUser; // Devuelve el AppUser global

  void _listenAuthState() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential authResult =
          await _firebaseAuth.signInWithCredential(credential);
      final User? firebaseUser = authResult.user;

      if (firebaseUser != null) {
        // Asumimos que firebaseUser tiene email y displayName no nulos
        CreateUserDto newUser = CreateUserDto(
          fullName: firebaseUser.displayName ?? 'null',
          email: firebaseUser.email ?? 'no-email@example.com',
          password: firebaseUser
              .uid, // Este campo podría ser opcional o gestionado de forma diferente
        );
        await register(newUser); // Registra el usuario en tu backend
      }
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
  }

  Future<void> register(CreateUserDto user) async {
    var url = Uri.parse('http://localhost:3000/user');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode(user.toJson());

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        currentUser = UserAuth.fromJson(data);
        notifyListeners(); // Notify listeners that the global user has been updated
        if (currentUser != null) {
          await tokenStorage.saveUser(
              currentUser!); // Save non-null user data to secure storage
        } else {
          // Handle the case where currentUser is null
          print('Error: currentUser is null');
        }
        print(currentUser); // For debugging
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error making the request: $e');
    }
  }

  void signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
