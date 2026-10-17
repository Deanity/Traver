class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final int sortOrder;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.sortOrder,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }

  String get imagePath {
    switch (id.toLowerCase()) {
      case 'beach':
        return 'assets/images/categories/beach.png';
      case 'mountain':
        return 'assets/images/categories/mountain.png';
      case 'forest':
        return 'assets/images/categories/forest.png';
      case 'ocean':
        return 'assets/images/categories/ocean.png';
      case 'camping':
        return 'assets/images/categories/camping.png';
      case 'fishing':
        return 'assets/images/categories/fishing.png';
      default:
        return 'assets/images/categories/mountain.png';
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'sortOrder': sortOrder,
      };
}
