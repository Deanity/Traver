import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traver/core/services/local_storage.dart';
import 'package:traver/features/auth/data/user_model.dart';
import 'package:traver/features/auth/presentation/session_provider.dart';
import 'package:traver/features/destination/data/destination_model.dart';
import 'package:traver/features/destination/data/destination_repository.dart';
import 'package:traver/features/home/data/category_model.dart';
import 'package:traver/features/home/data/category_repository.dart';
import 'package:traver/features/home/presentation/screens/home_screen.dart';

void main() {
  final mockCategories = [
    const CategoryModel(id: 'beach', name: 'Beach', icon: 'beach.svg', sortOrder: 1),
    const CategoryModel(id: 'mountain', name: 'Mountain', icon: 'mountain.svg', sortOrder: 2),
    const CategoryModel(id: 'forest', name: 'Forest', icon: 'forest.svg', sortOrder: 3),
  ];

  final mockDestinations = [
    const DestinationModel(
      id: 'dest_001',
      name: 'Kuta Beach',
      location: 'Bali, Indonesia',
      category: 'beach',
      price: 245.0,
      currency: 'USD',
      priceUnit: 'per_person',
      durationDays: 4,
      maxGuests: 10,
      rating: 4.8,
      reviewCount: 120,
      images: ['assets/images/destinations/kuta_beach.png'],
      included: ['flight', 'hotel'],
      about: 'Kuta beach description',
      isPopular: true,
      isActive: true,
    ),
    const DestinationModel(
      id: 'dest_002',
      name: 'Mount Bromo',
      location: 'East Java, Indonesia',
      category: 'mountain',
      price: 120.0,
      currency: 'USD',
      priceUnit: 'per_person',
      durationDays: 3,
      maxGuests: 8,
      rating: 4.9,
      reviewCount: 145,
      images: ['assets/images/destinations/bromo.png'],
      included: ['hotel'],
      about: 'Bromo description',
      isPopular: true,
      isActive: true,
    ),
    const DestinationModel(
      id: 'dest_005',
      name: 'Kuta Resort',
      location: 'Bali, Indonesia',
      category: 'beach',
      price: 745.0,
      currency: 'USD',
      priceUnit: 'per_person',
      durationDays: 4,
      maxGuests: 8,
      rating: 4.8,
      reviewCount: 156,
      images: ['assets/images/destinations/kuta_resort.png'],
      included: ['flight', 'hotel'],
      about: 'A resort is a place used for vacation, relaxation or as a day...',
      isPopular: true,
      isActive: true,
    ),
    const DestinationModel(
      id: 'dest_006',
      name: 'Jepara Resort',
      location: 'Central Java, Indonesia',
      category: 'beach',
      price: 545.0,
      currency: 'USD',
      priceUnit: 'per_person',
      durationDays: 3,
      maxGuests: 6,
      rating: 4.8,
      reviewCount: 112,
      images: ['assets/images/destinations/jepara_resort.png'],
      included: ['hotel'],
      about: 'A resort is a place used for vacation, relaxation or as a day...',
      isPopular: true,
      isActive: true,
    ),
  ];

  testWidgets('HomeScreen renders all elements from Homepage mockup properly', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          categoriesProvider.overrideWith((ref) => mockCategories),
          destinationsProvider.overrideWith((ref) => mockDestinations),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Header
    expect(find.text('Hello, Pristia!'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);

    // 2. Exploration Title
    expect(find.text('Where do you\nwant to explore today?'), findsOneWidget);

    // 3. Search Bar
    expect(find.text('Search destination'), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);

    // 4. Category Section
    expect(find.text('Choose Category'), findsOneWidget);
    expect(find.text('Beach'), findsOneWidget);
    expect(find.text('Mountain'), findsOneWidget);
    expect(find.text('Forest'), findsOneWidget);

    // 5. Favorite Place Section
    expect(find.text('Favorite Place'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Kuta Beach'), findsWidgets);
    expect(find.text('Bali, Indonesia'), findsWidgets);

    // 6. Popular Package Section
    expect(find.text('Popular Package'), findsOneWidget);
    expect(find.text('Kuta Resort'), findsOneWidget);
    expect(find.text('\$745,00'), findsOneWidget);
    expect(find.text('Jepara Resort'), findsOneWidget);
    expect(find.text('\$545,00'), findsOneWidget);
  });

  testWidgets('HomeScreen displays dynamic user name when logged in', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    const customUser = UserModel(
      id: 'usr_099',
      name: 'Alexander Great',
      email: 'alex@traver.app',
      emailVerified: true,
      favoriteCategories: ['beach'],
    );

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        categoriesProvider.overrideWith((ref) => mockCategories),
        destinationsProvider.overrideWith((ref) => mockDestinations),
      ],
    );

    // Set logged in session
    container.read(sessionProvider.notifier).login(customUser);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Greeting should show user first name
    expect(find.text('Hello, Alexander!'), findsOneWidget);
  });

  testWidgets('Tapping wishlist heart toggles favorite state reactively', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          categoriesProvider.overrideWith((ref) => mockCategories),
          destinationsProvider.overrideWith((ref) => mockDestinations),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Find heart icon on Kuta Beach card or favorite places
    final heartBorderFinders = find.byIcon(Icons.favorite_border_rounded);
    expect(heartBorderFinders, findsWidgets);

    // Tap first heart
    await tester.tap(heartBorderFinders.first);
    await tester.pumpAndSettle();

    // Expect at least one filled heart icon now
    expect(find.byIcon(Icons.favorite_rounded), findsWidgets);
  });
}
