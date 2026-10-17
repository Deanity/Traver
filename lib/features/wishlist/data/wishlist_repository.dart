import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:traver/core/constants/app_constants.dart';
import 'package:traver/core/services/local_storage.dart';
import 'package:traver/features/auth/presentation/session_provider.dart';

class WishlistNotifier extends StateNotifier<Set<String>> {
  final LocalStorage _storage;
  final String _userId;

  WishlistNotifier({
    required LocalStorage storage,
    required String userId,
  })  : _storage = storage,
        _userId = userId,
        super({}) {
    _loadWishlist();
  }

  void _loadWishlist() {
    final key = StorageKeys.wishlist(_userId);
    final raw = _storage.getJson(key);
    if (raw is List) {
      state = raw.map((e) => e.toString()).toSet();
    } else {
      state = {};
    }
  }

  bool isFavorite(String destinationId) {
    return state.contains(destinationId);
  }

  Future<void> toggle(String destinationId) async {
    final updated = Set<String>.from(state);
    if (updated.contains(destinationId)) {
      updated.remove(destinationId);
    } else {
      updated.add(destinationId);
    }
    state = updated;

    final key = StorageKeys.wishlist(_userId);
    await _storage.setJson(key, updated.toList());
  }

  Future<void> add(String destinationId) async {
    if (!state.contains(destinationId)) {
      final updated = Set<String>.from(state)..add(destinationId);
      state = updated;
      await _storage.setJson(StorageKeys.wishlist(_userId), updated.toList());
    }
  }

  Future<void> remove(String destinationId) async {
    if (state.contains(destinationId)) {
      final updated = Set<String>.from(state)..remove(destinationId);
      state = updated;
      await _storage.setJson(StorageKeys.wishlist(_userId), updated.toList());
    }
  }
}

final wishlistProvider = StateNotifierProvider<WishlistNotifier, Set<String>>((ref) {
  final storage = ref.watch(localStorageProvider);
  final session = ref.watch(sessionProvider);
  final userId = session.user?.id ?? 'guest';

  return WishlistNotifier(storage: storage, userId: userId);
});
