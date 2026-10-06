import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final SharedPreferences _prefs;

  LocalStorage(this._prefs);

  String? getString(String key) => _prefs.getString(key);
  Future<bool> setString(String key, String value) => _prefs.setString(key, value);

  bool? getBool(String key) => _prefs.getBool(key);
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  int? getInt(String key) => _prefs.getInt(key);
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  Future<bool> remove(String key) => _prefs.remove(key);

  dynamic getJson(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    try {
      return json.decode(raw);
    } catch (_) {
      return null;
    }
  }

  Future<bool> setJson(String key, dynamic value) {
    return _prefs.setString(key, json.encode(value));
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main');
});

final localStorageProvider = Provider<LocalStorage>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStorage(prefs);
});
