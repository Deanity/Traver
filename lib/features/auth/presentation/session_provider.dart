import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:traver/core/constants/app_constants.dart';
import 'package:traver/core/services/local_storage.dart';
import 'package:traver/features/auth/data/user_model.dart';

class SessionState {
  final UserModel? user;
  final bool isLoggedIn;

  const SessionState({this.user, this.isLoggedIn = false});
}

class SessionNotifier extends StateNotifier<SessionState> {
  final LocalStorage _storage;

  SessionNotifier(this._storage) : super(const SessionState()) {
    _init();
  }

  void _init() {
    final userId = _storage.getString(StorageKeys.sessionUserId);
    if (userId != null) {
      final usersRaw = _storage.getJson(StorageKeys.users);
      if (usersRaw is List) {
        try {
          final found = usersRaw.firstWhere(
            (u) => u is Map<String, dynamic> && u['id'] == userId,
            orElse: () => null,
          );
          if (found != null) {
            final user = UserModel.fromJson(found as Map<String, dynamic>);
            state = SessionState(user: user, isLoggedIn: true);
            return;
          }
        } catch (_) {}
      }
    }
    state = const SessionState(user: null, isLoggedIn: false);
  }

  Future<void> login(UserModel user, {bool rememberMe = true}) async {
    await _storage.setString(StorageKeys.sessionUserId, user.id);
    await _storage.setBool(StorageKeys.rememberMe, rememberMe);
    state = SessionState(user: user, isLoggedIn: true);
  }

  Future<void> logout() async {
    await _storage.remove(StorageKeys.sessionUserId);
    state = const SessionState(user: null, isLoggedIn: false);
  }

  Future<void> updateFavorites(List<String> categories) async {
    if (state.user == null) return;
    final updated = state.user!.copyWith(favoriteCategories: categories);
    state = SessionState(user: updated, isLoggedIn: true);

    // Update in users storage list
    final usersRaw = _storage.getJson(StorageKeys.users);
    if (usersRaw is List) {
      final updatedList = usersRaw.map((u) {
        if (u is Map<String, dynamic> && u['id'] == updated.id) {
          final copy = Map<String, dynamic>.from(u);
          copy['favoriteCategories'] = categories;
          return copy;
        }
        return u;
      }).toList();
      await _storage.setJson(StorageKeys.users, updatedList);
    }
  }
}

final sessionProvider = StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  final storage = ref.watch(localStorageProvider);
  return SessionNotifier(storage);
});

final onboardingDoneProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  final storage = ref.watch(localStorageProvider);
  return OnboardingNotifier(storage);
});

class OnboardingNotifier extends StateNotifier<bool> {
  final LocalStorage _storage;

  OnboardingNotifier(this._storage)
      : super(_storage.getBool(StorageKeys.onboardingDone) ?? false);

  Future<void> completeOnboarding() async {
    await _storage.setBool(StorageKeys.onboardingDone, true);
    state = true;
  }
}
