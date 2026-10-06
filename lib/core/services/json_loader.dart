import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JsonLoader {
  const JsonLoader();

  Future<Map<String, dynamic>> loadMap(String path) async {
    final String content = await rootBundle.loadString(path);
    return json.decode(content) as Map<String, dynamic>;
  }

  Future<List<dynamic>> loadList(String path) async {
    final String content = await rootBundle.loadString(path);
    return json.decode(content) as List<dynamic>;
  }
}

final jsonLoaderProvider = Provider<JsonLoader>((ref) => const JsonLoader());
