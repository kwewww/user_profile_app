import 'package:flutter/foundation.dart';
import 'package:user_profile_app/models/user_model.dart';
import 'package:user_profile_app/services/user_preferences_service.dart';

enum AuthFailure { emailAlreadyRegistered, invalidCredentials }

/// Coordinates authentication actions between the views and local storage.
class AuthController extends ChangeNotifier {
  AuthController(this._preferencesService);

  final UserPreferencesService _preferencesService;

  UserModel? _currentUser;
  bool _isLoadingSession = true;

  UserModel? get currentUser => _currentUser;
  bool get isLoadingSession => _isLoadingSession;
  bool get isLoggedIn => _currentUser != null;

  Future<void> restoreSession() async {
    _isLoadingSession = true;
    notifyListeners();

    try {
      _currentUser = await _preferencesService.getCurrentUser();
    } finally {
      _isLoadingSession = false;
      notifyListeners();
    }
  }

  Future<AuthFailure?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final users = await _preferencesService.getUsers();
    if (users.any((user) => user.email.toLowerCase() == normalizedEmail)) {
      return AuthFailure.emailAlreadyRegistered;
    }

    final user = UserModel(
      id: '${DateTime.now().microsecondsSinceEpoch}-$normalizedEmail',
      name: name.trim(),
      email: normalizedEmail,
      password: password,
      createdAt: DateTime.now(),
    );
    await _preferencesService.saveUser(user);
    await _preferencesService.setCurrentUser(user);
    _currentUser = user;
    notifyListeners();
    return null;
  }

  Future<AuthFailure?> signIn({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final users = await _preferencesService.getUsers();

    UserModel? matchingUser;
    for (final user in users) {
      if (user.email.toLowerCase() == normalizedEmail &&
          user.password == password) {
        matchingUser = user;
        break;
      }
    }

    if (matchingUser == null) return AuthFailure.invalidCredentials;

    await _preferencesService.setCurrentUser(matchingUser);
    _currentUser = matchingUser;
    notifyListeners();
    return null;
  }

  Future<void> signOut() async {
    await _preferencesService.clearCurrentUser();
    _currentUser = null;
    notifyListeners();
  }
}
