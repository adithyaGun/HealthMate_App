import '../model/use.dart';

class AuthRepository {
  // Simple in-memory "authentication"
  Future<User?> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Basic fake validation: accept any non-empty password/email
    if (email.isNotEmpty && password.length >= 4) {
      return User(id: DateTime.now().millisecondsSinceEpoch.toString(), email: email, name: 'User');
    }
    return null;
  }
}
