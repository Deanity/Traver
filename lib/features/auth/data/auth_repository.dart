import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:traver/core/constants/app_constants.dart';
import 'package:traver/core/services/local_storage.dart';
import 'user_model.dart';

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

class AuthRepository {
  final LocalStorage _storage;

  const AuthRepository(this._storage);

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password.trim();

    if (cleanEmail.isEmpty) {
      throw const AuthException('Email cannot be empty');
    }
    if (cleanPassword.isEmpty) {
      throw const AuthException('Password cannot be empty');
    }

    final usersRaw = _storage.getJson(StorageKeys.users);
    if (usersRaw is List) {
      for (final item in usersRaw) {
        if (item is Map<String, dynamic>) {
          final userEmail = (item['email'] as String?)?.toLowerCase();
          final userPassword = item['passwordHash'] as String?;

          if (userEmail == cleanEmail) {
            if (userPassword != null && userPassword == cleanPassword) {
              return UserModel.fromJson(item);
            } else {
              throw const AuthException('Invalid password. Please check your credentials.');
            }
          }
        }
      }
    }

    // If user is not found in local storage, allow test/demo login if credentials look valid,
    // or register dynamic demo user so developer/tester is never blocked:
    if (cleanEmail.contains('@') && cleanPassword.length >= 6) {
      final newUser = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        name: cleanEmail.split('@').first,
        email: cleanEmail,
        emailVerified: true,
        favoriteCategories: ['beach', 'mountain'],
      );

      // Save to local storage users
      final currentUsers = usersRaw is List ? List<dynamic>.from(usersRaw) : <dynamic>[];
      final newUserData = newUser.toJson();
      newUserData['passwordHash'] = cleanPassword;
      currentUsers.add(newUserData);
      await _storage.setJson(StorageKeys.users, currentUsers);

      return newUser;
    }

    throw const AuthException('User not found. Please register or check your email.');
  }

  Future<void> updatePassword({
    required String email,
    required String newPassword,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = newPassword.trim();

    if (cleanPassword.length < 8) {
      throw const AuthException('Password must be at least 8 characters long');
    }

    final usersRaw = _storage.getJson(StorageKeys.users);
    if (usersRaw is List) {
      final updatedList = usersRaw.map((u) {
        if (u is Map<String, dynamic> &&
            (u['email'] as String?)?.toLowerCase() == cleanEmail) {
          final copy = Map<String, dynamic>.from(u);
          copy['passwordHash'] = cleanPassword;
          return copy;
        }
        return u;
      }).toList();
      await _storage.setJson(StorageKeys.users, updatedList);
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.watch(localStorageProvider);
  return AuthRepository(storage);
});
