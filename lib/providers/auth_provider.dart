import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _loggedIn = false;
  bool _isLoading = false;

  bool get loggedIn => _loggedIn;
  bool get isLoading => _isLoading;

  Future<void> login() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _loggedIn = true;
    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _loggedIn = false;
    notifyListeners();
  }
}
