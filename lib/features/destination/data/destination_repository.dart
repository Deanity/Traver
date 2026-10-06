import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:traver/core/constants/app_constants.dart';
import 'package:traver/core/services/json_loader.dart';
import 'destination_model.dart';

abstract class DestinationRepository {
  Future<List<DestinationModel>> getAll();
  Future<DestinationModel?> getById(String id);
  Future<List<DestinationModel>> getPopular();
  Future<List<DestinationModel>> getByCategory(String categoryId);
}

class LocalDestinationRepository implements DestinationRepository {
  final JsonLoader _loader;
  List<DestinationModel>? _cache;

  LocalDestinationRepository(this._loader);

  Future<List<DestinationModel>> _load() async {
    if (_cache != null) return _cache!;
    final list = await _loader.loadList(AssetPaths.destinationsJson);
    _cache = list
        .map((e) => DestinationModel.fromJson(e as Map<String, dynamic>))
        .where((d) => d.isActive)
        .toList();
    return _cache!;
  }

  @override
  Future<List<DestinationModel>> getAll() async {
    return _load();
  }

  @override
  Future<DestinationModel?> getById(String id) async {
    final all = await _load();
    try {
      return all.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<DestinationModel>> getPopular() async {
    final all = await _load();
    return all.where((d) => d.isPopular).toList();
  }

  @override
  Future<List<DestinationModel>> getByCategory(String categoryId) async {
    final all = await _load();
    return all.where((d) => d.category.toLowerCase() == categoryId.toLowerCase()).toList();
  }
}

final destinationRepositoryProvider = Provider<DestinationRepository>((ref) {
  final loader = ref.watch(jsonLoaderProvider);
  return LocalDestinationRepository(loader);
});

final destinationsProvider = FutureProvider<List<DestinationModel>>((ref) {
  return ref.watch(destinationRepositoryProvider).getAll();
});
