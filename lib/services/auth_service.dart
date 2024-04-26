import 'package:finia_app/models/createUserDTO.dart';
import 'package:finia_app/responses/userResponse.dart';
import 'package:finia_app/storage/auth_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final GlobalKey<NavigatorState>? navigatorKey;

  UserAuth? currentUser; // Almacena la información del usuario globalmente
  bool isLoading = false;

  int _index = 0;

  // Getter to get the card number
  int get index => _index;

  // Setter to set the card number and notify listeners
  set cardSelectNumber(int newNumber) {
    _index = newNumber;
    notifyListeners(); // Notify all listening widgets of a change
  }

  String? _cardsHero = 'cardsHome';

  // Getter to get the card number
  String? get cardsHero => _cardsHero;

  // Setter to set the card number and notify listeners
  set cardsHero(String? value) {
    _cardsHero = value;
    notifyListeners(); // Notify all listening widgets of a change
  }

  final TokenStorage tokenStorage = TokenStorage();

  AuthService({this.navigatorKey}) {
    loadUserData();
    _listenAuthState();
  }

  // Method to check the validity of the session
  Future<bool> checkSession() async {
    // Try to refresh the token to check session validity
    bool isTokenRefreshed = await refreshToken();
    if (isTokenRefreshed) {
      // If the token is successfully refreshed, the session is valid
      return true;
    } else {
      // If the token could not be refreshed, it may be expired or invalid
      return false;
    }
  }

  Future<void> loadUserData() async {
    currentUser = await tokenStorage.getUser();
    if (currentUser != null) {
      notifyListeners();
    }
  }

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
  bool get isAuthenticated => globalUser != null;
  UserAuth? get globalUser => currentUser; // Devuelve el AppUser global

  void _listenAuthState() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user == null) {
        signOut(); // Automatically sign out when user is null
      }
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
    isLoading =
        true; // Establecer isLoading como true antes de realizar la solicitud de registro
    notifyListeners();

    var url = Uri.parse('http://localhost:3000/user');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode(user.toJson());

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        if (data != null && data is Map<String, dynamic>) {
          if (data['accessToken'] != null && data['refreshToken'] != null) {
            await tokenStorage.saveToken(
                data['accessToken'], data['refreshToken']);

            currentUser = UserAuth.fromJson(data);
            if (currentUser != null) {
              await tokenStorage.saveUser(currentUser!);
              notifyListeners();
            } else {
              print('Error: Failed to create user object from data');
            }
          } else {
            print('Error: Missing tokens in response');
          }
        } else {
          print('Error: Response format is incorrect');
        }
      } else {
        print('Registration failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error making the registration request: $e');
    } finally {
      isLoading =
          false; // Establecer isLoading como false después de completar la solicitud de registro
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      await tokenStorage.deleteAllTokens();
      currentUser = null;
      isLogin = false;
      notifyListeners();
    } catch (error) {
      print('Failed to sign out: $error');
    }
  }
}
