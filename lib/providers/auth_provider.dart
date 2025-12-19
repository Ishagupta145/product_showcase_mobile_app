import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  // Simulate Login
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API delay
    
    // In a real app, you would send credentials to backend here
    if (email.isNotEmpty && password.length > 5) {
      await _storage.write(key: 'auth_token', value: 'dummy_token_123456');
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Simulate Logout
  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    _isAuthenticated = false;
    notifyListeners();
  }

  // Check token on app start
  Future<void> checkLoginStatus() async {
    String? token = await _storage.read(key: 'auth_token');
    _isAuthenticated = token != null;
    notifyListeners();
  }
}