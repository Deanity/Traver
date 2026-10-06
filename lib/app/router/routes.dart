class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String accountCreated = '/account-created';
  static const String favoritePlaces = '/favorite-places';

  // Shell Tabs
  static const String home = '/home';
  static const String trips = '/trips';
  static const String wishlist = '/wishlist';
  static const String profile = '/profile';

  // Sub routes
  static const String destinationDetail = '/destination/:id';
  static String destinationDetailPath(String id) => '/destination/$id';

  static const String search = '/search';
  static const String category = '/category/:id';
  static String categoryPath(String id) => '/category/$id';

  static const String bookingDate = '/booking/:id/date';
  static const String bookingForm = '/booking/form';
  static const String bookingPayment = '/booking/payment';
  static const String bookingSuccess = '/booking/success';
  static const String notifications = '/notifications';
}
