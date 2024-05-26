import 'package:flutter/material.dart';
import 'package:stocklab_fe/network/AuthService.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Map<String, dynamic>? _userData; // Variabel untuk menyimpan data user

  Map<String, dynamic>? get userData => _userData; // Getter untuk data user

  set userData(Map<String, dynamic>? data) {
    _userData = data;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      Map<String, dynamic> result = await AuthService.login(email, password);
      if (result['success']) {
        _isLoggedIn = true;
        userData = result['user'];
      }
    } catch (e) {
      // Handle error jika login gagal
      print('Error while logging in: $e');
    } finally {
      isLoading = false;
    }
    notifyListeners();
  }
}
