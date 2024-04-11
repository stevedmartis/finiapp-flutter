import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user; // Almacenar el usuario actual

  AuthService() {
    _listenAuthState();
  }

  bool isLogin = false;
  bool get isAuthenticated => _user != null;
  User? get user => _user;

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
      await _firebaseAuth.signInWithCredential(credential);

      // No es necesario actualizar _user o llamar a notifyListeners aquí,
      // ya que _listenAuthState() se encargará de esto.
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      // Similarmente, no es necesario manejar _user o _isAuthenticated aquí,
      // el escuchador de estado se encargará de cualquier cambio.
    }
  }

  void signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    // Similar al caso de signIn, no es necesario limpiar _user aquí.
  }
}
