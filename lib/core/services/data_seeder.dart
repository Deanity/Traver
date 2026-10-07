import '../services/json_loader.dart';
import '../services/local_storage.dart';
import '../constants/app_constants.dart';

class DataSeeder {
  final LocalStorage storage;
  final JsonLoader loader;

  const DataSeeder({
    required this.storage,
    required this.loader,
  });

  static const int currentSeedVersion = 2;

  Future<void> seedIfNeeded() async {
    final existingVersion = storage.getInt(StorageKeys.seedVersion) ?? 0;
    if (existingVersion >= currentSeedVersion) {
      return;
    }

    try {
      final users = await loader.loadList(AssetPaths.usersJson);
      await storage.setJson(StorageKeys.users, users);

      final bookings = await loader.loadList(AssetPaths.bookingsJson);
      final wishlists = await loader.loadList(AssetPaths.wishlistsJson);
      final searchHistory = await loader.loadList(AssetPaths.searchHistoryJson);
      final notifications = await loader.loadList(AssetPaths.notificationsJson);

      for (final rawUser in users) {
        if (rawUser is Map<String, dynamic>) {
          final userId = rawUser['id'] as String;

          final userBookings = bookings.where((b) => b['userId'] == userId).toList();
          await storage.setJson(StorageKeys.bookings(userId), userBookings);

          final userWishlist = wishlists
              .where((w) => w['userId'] == userId)
              .map((w) => w['destinationId'])
              .toList();
          await storage.setJson(StorageKeys.wishlist(userId), userWishlist);

          final userSearch = searchHistory.where((s) => s['userId'] == userId).toList();
          await storage.setJson(StorageKeys.searchHistory(userId), userSearch);

          final userNotifications = notifications
              .where((n) => n['userId'] == userId || n['userId'] == null)
              .toList();
          await storage.setJson(StorageKeys.notifications(userId), userNotifications);
        }
      }

      await storage.setInt(StorageKeys.seedVersion, currentSeedVersion);
    } catch (e) {
      // Seeding failure should not crash the app, but log for debugging
      debugPrint('DataSeeder error: $e');
    }
  }
}

void debugPrint(String message) {
  // Simple print for debug
  // ignore: avoid_print
  print(message);
}
