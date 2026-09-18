import 'package:flutter/foundation.dart';
import 'package:user_profile_app/core/app_logger.dart';
import 'package:user_profile_app/models/user_model.dart';
import 'package:user_profile_app/services/user_preferences_service.dart';

enum AuthFailure { emailAlreadyRegistered, invalidCredentials, storageFailure }

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
    AppLogger.info('Checking stored active-user session.');
    _isLoadingSession = true;
    notifyListeners();

    try {
      _currentUser = await _preferencesService.getCurrentUser();
      AppLogger.info(
        _currentUser == null
            ? 'No valid active user found; showing sign-in.'
            : 'Valid active user found; showing profile.',
      );
    } catch (error, stackTrace) {
      _currentUser = null;
      AppLogger.error('Unable to restore the active-user session', error, stackTrace);
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
    AppLogger.info('Creating a local user account.');
    try {
      final normalizedEmail = email.trim().toLowerCase();
      final users = await _preferencesService.getUsers();
      if (users.any((user) => user.email.toLowerCase() == normalizedEmail)) {
        AppLogger.warning('Account creation stopped: email is already registered.');
        return AuthFailure.emailAlreadyRegistered;
      }

      final user = UserModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name.trim(),
        email: normalizedEmail,
        password: password,
        createdAt: DateTime.now(),
      );
      await _preferencesService.saveUser(user);
      await _preferencesService.setCurrentUser(user);
      _currentUser = user;
      AppLogger.info('Account created and active-user session saved.');
      notifyListeners();
      return null;
    } catch (error, stackTrace) {
      AppLogger.error('Unable to create the local user account', error, stackTrace);
      return AuthFailure.storageFailure;
    }
  }

  Future<AuthFailure?> signIn({
    required String email,
    required String password,
  }) async {
    AppLogger.info('Attempting local sign-in.');
    try {
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

      if (matchingUser == null) {
        AppLogger.warning('Sign-in rejected: no matching local user.');
        return AuthFailure.invalidCredentials;
      }

      await _preferencesService.setCurrentUser(matchingUser);
      _currentUser = matchingUser;
      AppLogger.info('Sign-in succeeded; active-user session saved.');
      notifyListeners();
      return null;
    } catch (error, stackTrace) {
      AppLogger.error('Unable to sign in using local storage', error, stackTrace);
      return AuthFailure.storageFailure;
    }
  }

  Future<void> signOut() async {
    AppLogger.info('Signing out the active local user.');
    try {
      await _preferencesService.clearCurrentUser();
      _currentUser = null;
      AppLogger.info('Active-user session cleared; showing sign-in.');
      notifyListeners();
    } catch (error, stackTrace) {
      AppLogger.error('Unable to clear the active-user session', error, stackTrace);
    }
  }
}
