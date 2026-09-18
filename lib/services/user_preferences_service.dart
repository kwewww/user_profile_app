import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_profile_app/core/app_logger.dart';
import 'package:user_profile_app/models/user_model.dart';

/// Persists registered users and the active user for this local-only app.
class UserPreferencesService {
  static const _usersKey = 'registered_users';
  static const _currentUserIdKey = 'current_user_id';

  Future<List<UserModel>> getUsers() async {
    final preferences = await SharedPreferences.getInstance();
    final storedUsers = preferences.getStringList(_usersKey) ?? const [];

    final users = <UserModel>[];
    for (final storedUser in storedUsers) {
      try {
        users.add(UserModel.fromJson(storedUser));
      } catch (_) {
        AppLogger.warning('Ignored an invalid locally stored user record.');
        // Ignore invalid legacy data rather than preventing the app from opening.
      }
    }
    AppLogger.info('Loaded ${users.length} local user record(s).');
    return users;
  }

  Future<void> saveUser(UserModel user) async {
    final preferences = await SharedPreferences.getInstance();
    final users = await getUsers();
    final updatedUsers = [
      for (final existingUser in users)
        if (existingUser.id != user.id) existingUser,
      user,
    ];

    await preferences.setStringList(
      _usersKey,
      updatedUsers.map((storedUser) => storedUser.toJson()).toList(),
    );
    AppLogger.info('Saved local user records.');
  }

  Future<UserModel?> getCurrentUser() async {
    final preferences = await SharedPreferences.getInstance();
    final currentUserId = preferences.getString(_currentUserIdKey);
    if (currentUserId == null || currentUserId.isEmpty) {
      AppLogger.info('No active-user ID is stored.');
      return null;
    }

    final users = await getUsers();
    for (final user in users) {
      if (user.id == currentUserId) {
        AppLogger.info('Active-user ID matched a stored user.');
        return user;
      }
    }

    // A removed or corrupt account must not leave an invalid session behind.
    await preferences.remove(_currentUserIdKey);
    AppLogger.warning('Removed an active-user ID without a matching user.');
    return null;
  }

  Future<void> setCurrentUser(UserModel user) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_currentUserIdKey, user.id);
    AppLogger.info('Saved the active-user ID.');
  }

  Future<void> clearCurrentUser() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_currentUserIdKey);
    AppLogger.info('Removed the active-user ID.');
  }

  /// A small helper for tests and future migrations that need the raw payload.
  Future<String?> getCurrentUserId() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_currentUserIdKey);
  }
}
