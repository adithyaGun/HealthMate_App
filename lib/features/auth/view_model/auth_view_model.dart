import 'package:flutter/material.dart';
import '../repository/auth_repository.dart';
import '../model/use.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();
  User? user;
  bool loading = false;
  String? error;

  Future<bool> login(String email, String password) async {
    loading = true;
    error = null;
    notifyListeners();

    final result = await _repo.login(email.trim(), password);
    loading = false;

    if (result != null) {
      user = result;
      notifyListeners();
      return true;
    } else {
      error = 'Invalid credentials';
      notifyListeners();
      return false;
    }
  }

  void logout() {
    user = null;
    notifyListeners();
  }
}
