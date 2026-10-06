import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app.dart';
import 'core/services/data_seeder.dart';
import 'core/services/json_loader.dart';
import 'core/services/local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final storage = LocalStorage(prefs);
  const loader = JsonLoader();

  // 2. Perform dummy data seeding if needed
  final seeder = DataSeeder(storage: storage, loader: loader);
  await seeder.seedIfNeeded();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const TraverApp(),
    ),
  );
}
