import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  GoogleSignInAccount? _currentUser;

  GoogleSignInAccount? get currentUser => _currentUser;

  AuthProvider() {
    _initializeGoogleSignIn();
  }

  Future<void> _initializeGoogleSignIn() async {
    _googleSignIn.authenticationEvents.listen((event) {
      _currentUser = switch (event) {
        GoogleSignInAuthenticationEventSignIn() => event.user,
        GoogleSignInAuthenticationEventSignOut() => null,
      };
      notifyListeners();
    }, onError: (error) {
      print('Authentication Error: $error');
      _currentUser = null;
      notifyListeners();
    });

    await _googleSignIn.initialize(
      clientId: '284915159930-rs7kkhuhtocnud16e7kg30sdck1jv8qg.apps.googleusercontent.com',
    );

    await _googleSignIn.attemptLightweightAuthentication();
  }

  Future<void> signIn() async {
    try {
      if (!kIsWeb) {
        //await _googleSignIn.signIn();
      } else {
        print("Web sign-in must use renderButton or platform-native UI");
      }
    } catch (error) {
      print('Error during sign-in: $error');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
  }
}
