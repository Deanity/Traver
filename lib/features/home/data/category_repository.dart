import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:traver/core/constants/app_constants.dart';
import 'package:traver/core/services/json_loader.dart';
import 'category_model.dart';

abstract class CategoryRepository {
  Future<List<CategoryModel>> getAll();
}

class LocalCategoryRepository implements CategoryRepository {
  final JsonLoader _loader;
  List<CategoryModel>? _cache;

  LocalCategoryRepository(this._loader);

  @override
  Future<List<CategoryModel>> getAll() async {
    if (_cache != null) return _cache!;
    final list = await _loader.loadList(AssetPaths.categoriesJson);
    final items = list.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
    items.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    _cache = items;
    return _cache!;
  }
}

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final loader = ref.watch(jsonLoaderProvider);
  return LocalCategoryRepository(loader);
});

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) {
  return ref.watch(categoryRepositoryProvider).getAll();
});
