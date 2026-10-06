class StorageKeys {
  StorageKeys._();

  static const String seedVersion = 'seed_version';
  static const String onboardingDone = 'onboarding_done';
  static const String sessionUserId = 'session_user_id';
  static const String rememberMe = 'remember_me';
  static const String users = 'users';

  // Dynamic user specific keys
  static String bookings(String userId) => 'bookings_$userId';
  static String wishlist(String userId) => 'wishlist_$userId';
  static String searchHistory(String userId) => 'search_history_$userId';
  static String notifications(String userId) => 'notifications_$userId';
}

class AssetPaths {
  AssetPaths._();

  // Data
  static const String destinationsJson = 'assets/data/destinations.json';
  static const String categoriesJson = 'assets/data/categories.json';
  static const String reviewsJson = 'assets/data/reviews.json';
  static const String usersJson = 'assets/data/users.json';
  static const String notificationsJson = 'assets/data/notifications.json';
  static const String paymentMethodsJson = 'assets/data/payment_methods.json';
  static const String bookingsJson = 'assets/data/bookings.json';
  static const String wishlistsJson = 'assets/data/wishlists.json';
  static const String searchHistoryJson = 'assets/data/search_history.json';

  // Onboarding
  static const String onboarding1 = 'assets/onBoardingImage/Image-1.png';
  static const String onboarding2 = 'assets/onBoardingImage/Image-2.png';
  static const String onboarding3 = 'assets/onBoardingImage/Image-3.png';
}
