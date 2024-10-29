import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  Future<bool> login() async {
    _isLoading = true;
    notifyListeners();

    // Simulate a network request
    await Future.delayed(Duration(seconds: 2));

    // For demo purposes, consider login successful if email is not empty
    bool success = _email.isNotEmpty;

    _isLoading = false;
    notifyListeners();

    return success;
  }
}
